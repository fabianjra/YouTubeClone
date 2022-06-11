//
//  RootPageViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

//Patron delegate. Va a permitir que si se llama desde otra pantalla, se llame a una funcion de aqui.
//AnyObject porque va a ser un Weak.
protocol RootPageProtocol: AnyObject{
    func currentPage(_ index: Int)
}

class RootPageViewController: UIPageViewController {
    
    //Guarda los ViewController creados en un array, para usarlos para navegar entre ellos.
    var subViewControllers = [UIViewController]()
    var currentIndex: Int = 0 //Variable global para saber en que TAG (Index) de ViewController se encuentra, aignada al final de moverse.
    weak var delegateRoot : RootPageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setupViewControllers()
    }
    
    //Llena el array con los viewControllers.
    private func setupViewControllers(){
        subViewControllers = [
            HomeViewController(),
            VideosViewController(),
            PlaylistsViewController(),
            ChannelsViewController(),
            AboutViewController()
        ]
        
        //Ponerles Tags a cada ViewController para poder identificarlos. se usa MAP en lugar de FOR para recorrerlos.
        _ = subViewControllers.enumerated().map( { $0.element.view.tag = $0.offset} )
        
        //El similar a lo anterior, seria lo siguiente:
        //for (offset, element) in subViewControllers.enumerated() {}
        
        //Inicializa un viewControoller en index 0 y en direccion hacia adelante.
        setViewControllerFromIndex(index: 0, direction: .forward)
    }
    
    //Funcion publica para poder navegar entre ViewControllers en base a un Index.
    func setViewControllerFromIndex(index: Int, direction: NavigationDirection, animated: Bool = true){
        setViewControllers([subViewControllers[index]], direction: direction, animated: animated)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
extension RootPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        
        if index <= 0 {
            return nil
        }else{
            return subViewControllers[index - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        
        if index >= (subViewControllers.count - 1) {
            return nil
        }else{
            return subViewControllers[index + 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        //Busca dentro de los ViewController el TAG, y asignaselo a Index.
        if let index = pageViewController.viewControllers?.first?.view.tag{
            currentIndex = index
            
            delegateRoot?.currentPage(index) //Realiza un llamado a la funcion en otro ViewController. (llama a MainViewController y permite hacer uso del valor que pasa por parametro Index).
        }
    }
}
