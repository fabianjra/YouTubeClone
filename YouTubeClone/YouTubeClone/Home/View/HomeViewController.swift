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
        
        //Se utiliza await porque el metodo que se llama es Async.
        //Se utiliza Task porque el ViewDidLoad no puede ser Async.
        Task{
            await presenter.getHomeObjects()
        }
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
