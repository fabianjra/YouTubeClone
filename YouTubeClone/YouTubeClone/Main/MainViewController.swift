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
    var currentPageIndex: Int = 0 //Maneja cual pagina se selecciona en el NavBar
    
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
    }
    
    
}

extension MainViewController: TabsViewProtocol {
    
    func didSelectOption(index: Int) {
         print("Se selecciono: ", options[index])
        
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
