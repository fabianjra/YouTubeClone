//
//  HomeViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //1: El lazy se utiliza para que no de error, a la hora de pasarle self a la instancia.
    //2: No es necesario psar el provider, porque ya desde el INIT en la calse HomePresenter, se está asignando que clase usar.
    lazy var presenter = HomePresenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

extension HomeViewController: HomeViewProtocol{
    
    func getData(list: [[Any]]) {
        print("Lista: ", list)
    }
    
    
}
