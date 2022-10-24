//
//  TabsView.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 19/10/22.
//

import Foundation
import UIKit

//Usar patron delegation, para poder comunicar la clase externa con esta y enviarle a esta el array de strings "options".
//AnyObjecto se usa porque: para poder ponerle weak a la variable
protocol TabsViewProtocol: AnyObject {
    func didSelectOption(index: Int)
}

class TabsView: UIView {
    
    //Manejar el tab blanco debajo del texto, que se va a mover conforme a cual pantalla se mueve.
    var underline: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .whiteColor
        
        return view
    }()
    
    //Manejo de index de la pantalla seleccionada actualmente.
    var selectedItem: IndexPath = IndexPath(item: Int.zero, section: Int.zero)
    
    //Variable que va a manejar el ancho y el leading (izquierda) del objeto (underline).
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    
    //Estos 2 metodos de required: se deben agregar por haber agregado el CollectionView por codigo.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //Las opciones que va a tener el CollectionView, se van a inyectar desde afuera.
    private var options: [String] = []
    weak private var delegate: TabsViewProtocol? //debe ser weak por el Memory leak.
    
    func buildView(delegate: TabsViewProtocol, options: [String]){
        self.delegate = delegate
        self.options = options
        
        collectionView.reloadData()
        
        //Se ejecuta luego de 0.1 segundos, para garantizar que se haya cargado la vista y asi configurar el underline.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.configUnderline()
        }
    }
    
    //Se agrega la vista y Se agregan los constraing con valores de cero.
    private func configCollectionView(){
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    //Contstraints del Underline para el manejo de seleccion de pantalla actual.
    private func configUnderline(){
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 2.0), //Va a tener una altura de 2 puntos (o pixeles)
            underline.bottomAnchor.constraint(equalTo: bottomAnchor) //va a estar en la parte inferior.
        ])
        
        //Se setea la primera celda como seleccionada por defecto.
        let currentCell = collectionView.cellForItem(at: selectedItem)!
        
        //Se configura el ancho del objeto underline, del mismo tamaño de la celda seleccionada,  en el collectionView (textos Tabs de las pantallas).
        widthConstraint = underline.widthAnchor.constraint(equalToConstant: currentCell.frame.width)
        widthConstraint?.isActive = true
        
        //Se configura el leading del Unicerline, igual al de la celda.
        leadingConstraint = underline.leadingAnchor.constraint(equalTo: currentCell.leadingAnchor)
        leadingConstraint?.isActive = true
    }
    
    //Otiene la posicion X del objeto y su ancho.
    func updateUnderline(xOrigin: CGFloat, width: CGFloat){
        leadingConstraint?.constant = xOrigin
        widthConstraint?.constant = width

        //Actualiza el Layout en caso de necesitarlo.
        layoutIfNeeded()
    }
    
    //Se crea un collectionView por codigo, para el TabView que va a tener todas las vistas en un scroll horizontal.
    //Un CollectionView puede tener scroll tanto Horizontal como vertial.
    //Se utiliza Lazy, porque para inicializar el frame del CollectionView, se esta llanado a Self. (implicitamente el frame es self).
    lazy var collectionView: UICollectionView = {
        
        //Hace que el scroll solamente sea horizontal.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false //Evita problemas al construir los constraint.
        collection.backgroundColor = .backgroundColor
        
        //Registrar cell
        collection.register(UINib(nibName: "\(OptionCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(OptionCell.self)")
        
        return collection
    }()
}

extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OptionCell.self)", for: indexPath) as? OptionCell else {
            return UICollectionViewCell()
        }
        
        //Valida que sea la primera iteracion que haga.
        if indexPath.row == 0 {
            cell.highlightTitle(.whiteColor)
        }else{
            cell.isSelected = (selectedItem.item == indexPath.row) //Actualiza el isSelected.
        }
        
        //Al indexPat, puede ser .item o .row (es lo mismo
        cell.configCell(option: options[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectOption(index: indexPath.item)
    }
}

extension TabsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Se asigna el tamaño del ancho de cada item, al tamaño de la letra de cada una, porque cada letra es de un ancho diferente.
        let label = UILabel()
        label.text = options[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16)
        
        let extraPadding: Double = 20.0
        
        //El alto va a ser el mismo de self, o sea el padre. (el self no hace falta, va implicito).
        return CGSize(width: label.intrinsicContentSize.width + extraPadding, height: frame.height)
    }
    
    //Permite modificar el espacio de cada item en el CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
