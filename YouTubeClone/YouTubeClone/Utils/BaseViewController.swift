//
//  BaseViewController.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 18/10/22.
//

import UIKit

//Se crea esta clase como un tipo de Master Page para utilizarla como base y mostrar siempre el NavigationBar superior.
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func configNavigationbar(){
        
        //Se crea el StackView que va a tener los 3 botones superiores qeu se deben ocultar cuando la pantalla baja.
        let stackOptions = UIStackView()
        stackOptions.axis = .horizontal //Va a ser horizontal.
        stackOptions.distribution = .fillEqually //Se va a llenar de manera uniforma (mismo tamaño)
        stackOptions.spacing = CGFloat.zero //va a tener cero espacio entre el y el del lado.
        stackOptions.translatesAutoresizingMaskIntoConstraints = false //Se indica que se van a construir los contraints de manera manual.
        
        //Se crean los botones en base al metodo de construccion de boton.
        let share = buildButtons(selector: #selector(shareButtonPressed), image: .castImage, inset: 30)
        let magnify = buildButtons(selector: #selector(magnifyButtonPressed), image: .magnifyingImage, inset: 33)
        let dots = buildButtons(selector: #selector(dotsButtonPressed), image: .dotsImage, inset: 33)
        
        //Se agregan los botones al stack
        stackOptions.addArrangedSubview(share)
        stackOptions.addArrangedSubview(magnify)
        stackOptions.addArrangedSubview(dots)
        
        //Se crea el Constraint del stack y se activa.
        stackOptions.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        //Se le indica al Navigation, que a la derecha va a tener un CustomView.
        let customItemView = UIBarButtonItem(customView: stackOptions)
        customItemView.tintColor = .clear
        navigationItem.rightBarButtonItem = customItemView
    }
    
    //Metodo paara no repetir codigo creando los iconos que va a tener el HorizontalStack
    private func buildButtons(selector: Selector, image: UIImage, inset: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .whiteColor
        
        let extraPadding: CGFloat = 2.0
        button.imageEdgeInsets = UIEdgeInsets(top: inset + extraPadding, left: inset, bottom: inset + extraPadding, right: inset)
        
        return button
    }
    
    //Acciones para los botones
    @objc func shareButtonPressed(){
        print("shareButtonPressed")
    }
    
    @objc func magnifyButtonPressed(){
        print("magnifyButtonPressed")
    }
    
    @objc func dotsButtonPressed(){
        print("dotsButtonPressed")
    }
}
