//
//  MainViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

//hereda del View base (un tipo de Master Page.
class MainViewController: BaseViewController {
    
    var rootPageViewController : RootPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se invoca al navigationBar de la clase base.
        configNavigationbar()
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
