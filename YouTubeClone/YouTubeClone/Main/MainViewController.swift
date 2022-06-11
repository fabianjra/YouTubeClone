//
//  MainViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var rootPageViewController : RootPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? RootPageViewController{
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }
    
}

//Se debe conformar el protocolo, ya que se esta usando el delegateRoot (el cual es de tipo RootPageProtocol).
extension MainViewController: RootPageProtocol{
    
    //Esta funcion es llamada externamente desde RootPageViewControoler.
    func currentPage(_ index: Int) {
        print("Pagina actual: ", index)
    }
    
    
}
