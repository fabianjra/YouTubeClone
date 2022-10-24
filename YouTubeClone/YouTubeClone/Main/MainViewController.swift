//
//  MainViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

//hereda del View base (un tipo de Master Page.
class MainViewController: BaseViewController {
    
    //IBOutlet:
    @IBOutlet weak var tabsView: TabsView!
    
    var rootPageViewController : RootPageViewController!
    private var options: [String] = ["HOME", "VIDEOS", "PLAYLIST", "CHANNEL", "ABOUT"]
    var prevPercent : CGFloat = CGFloat.zero
    
    //Para arreglar el problema de que cuando se toque un titulo del ColecctionView, el Underline no se posiciona en la celda correcta.
    //Lo que se gana con esta logica, es que como es una animacion, se inabilita la posibildiad de que se vuelva a hacer tap mientras la animacion corre.
    var didTapOption: Bool = false {
        didSet {
            if didTapOption {
                tabsView.isUserInteractionEnabled = false //Cancela los taps del Tab.
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.didTapOption.toggle()
                    self.tabsView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //Maneja cual pagina se selecciona en el NavBar
    var currentPageIndex: Int = 0 {
        
        //Valida que antes de cambiar el status, verifica el current de la pisicion y le va a decir a la celda el valor de isSelected.
        willSet {
            print("willSet: \(currentPageIndex)")
            
            let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
            cell?.isSelected = false
        }
        
        //Cuando ya se realice el cambio, valida que root exista y en caso de ser, le pasa el nuevo currentPageIndex y marca la celda como isSelected.
        didSet {
            print("didSet: \(currentPageIndex)")
            
            if let _ = rootPageViewController {
                rootPageViewController.currentPage = currentPageIndex
                
                let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
                cell?.isSelected = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se invoca al navigationBar de la clase base.
        configNavigationbar()
        
        //Se inicia el tabview con las opciones cargadas.
        tabsView.buildView(delegate: self, options: options)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? RootPageViewController{
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }
    
    //Se puede realizar un override a una funcion de la base, para poder hacer con ella cualquier logica.
    override func dotsButtonPressed() {
        print("Overrided dotsButtonPressed")
    }
    
}

//Se debe conformar el protocolo, ya que se esta usando el delegateRoot (el cual es de tipo RootPageProtocol).
extension MainViewController: RootPageProtocol{
    
    //Esta funcion es llamada externamente desde RootPageViewControoler.
    func currentPage(_ index: Int) {
        print("Pagina actual: ", index)
        
        currentPageIndex = index
        //Actualiza el atrituo SelectedItem, para poder manejar el Underline de la vista seleccionada.
        tabsView.selectedItem = IndexPath(item: index, section: 0)
    }
    
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int) {
        
        //Si el porcentaje es cero, es porque ya se detuvo la animacion (sin importar la direccion).
        //Se detiene el proceso para que no realice los calculos.
        if percent == CGFloat.zero || didTapOption {
            return
        }
        
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        // ---> [View]
        
        if direction == .goingRight {
            if index == options.count - 1 { return } //Valida que sea la ultima opcion, porque sino, no puede continuar y hace un return.
            
            //El next index seria el actual + 1
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index + 1, section: 0))
            
            //Se suma el acumulado, mas el % escroleado de la celda actual.
            let calculateNewLeading = currentCell!.frame.origin.x + (currentCell!.frame.width * percent)
            let newWidth = (prevPercent < percent) ? nextCell?.frame.width : currentCell?.frame.width
            
            //Se actualizan las variables con los constraints
            updateUnderlineConstraints(calculateNewLeading, newWidth!)
            
        } else { //Left [View] <---
            
            //Si está en la primera pagina y trata de moverse hacia la derecha, retorna.
            if index == 0 { return }
            
            //El next index seria el actual menos 1
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index - 1, section: 0))
            
            //Se suma el acumulado más el % escroleado de la celda actual.
            let calculateNewLeading = currentCell!.frame.origin.x - (nextCell!.frame.width * percent)
            let newWidth = prevPercent < percent ? nextCell?.frame.width : currentCell?.frame.width
            
            //Se actualizan las variables con los constraints.
            updateUnderlineConstraints(calculateNewLeading, newWidth!)
        }
        
        //Se guarda el valor previo para saber si va de derecha a izquierda dentro de la misma pagina.
        prevPercent = percent
    }
    
    func updateUnderlineConstraints(_ leading: CGFloat, _ width: CGFloat) {
        tabsView.leadingConstraint?.constant = leading
        tabsView.widthConstraint?.constant = width
        tabsView.layoutIfNeeded()
    }
}

extension MainViewController: TabsViewProtocol {
    
    func didSelectOption(index: Int) {
         print("Se selecciono: ", options[index])
        didTapOption = true
        
        //Entra a la vista del TabView, para seleccionar el Item en base al index, del CollectionView.
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))!
        
        //Indicarle a la celda que mueva el underline de la posicion anterior a la nueva (seleccinada).
        tabsView.updateUnderline(xOrigin: currentCell.frame.origin.x, width: currentCell.frame.width)
        
        //Mover a la pantalla correcta.
        //Por defecto la animacion va a ser hacia adelante la direccion (forward).
        var direction: UIPageViewController.NavigationDirection = .forward
        
        //Si se selecciona una pagina anterior a la actual, la animacion va a ser en direccion reversa.
        if index < currentPageIndex {
            direction = .reverse
        }
        
        //Esta funcion es la que indica realmente a qué index debe dirigirse la pagina, y la direccion es solamente para animacion.
        rootPageViewController.setViewControllerFromIndex(index: index, direction: direction)
        
        currentPageIndex = index
    }
}
