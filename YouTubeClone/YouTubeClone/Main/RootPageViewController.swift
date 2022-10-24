//
//  RootPageViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

//Permite saber si el swipe para pasar entre pantallas, va hacia un lado o a otro.
enum ScrollDirection {
    case goingLeft
    case goingRight
}

//Patron delegate. Va a permitir que si se llama desde otra pantalla, se llame a una funcion de aqui.
//AnyObject porque va a ser un Weak.
protocol RootPageProtocol: AnyObject{
    func currentPage(_ index: Int)
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int) //Permite
}

class RootPageViewController: UIPageViewController {
    
    //Guarda los ViewController creados en un array, para usarlos para navegar entre ellos.
    var subViewControllers = [UIViewController]()
    var currentIndex: Int = 0 //Variable global para saber en que TAG (Index) de ViewController se encuentra, aignada al final de moverse.
    weak var delegateRoot : RootPageProtocol?
    
    //Para el manejo del underline Tab
    var startOffset: CGFloat = CGFloat.zero
    var currentPage: Int = Int.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        delegateRoot?.currentPage(0) //Le indica al MainViewController que la posicion inicial de la pantalla va a ser cero.
        
        setupViewControllers()
        setScrollViewDelegate() //Asigna el delegate del srollView del swipe, para hacerele el override.
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
    
    //Actualiza el underline del Tab cuando se hace el Swipe, porque actualmente solo se actualiza cuando se presiona un boton del CollectionView.
    private func setScrollViewDelegate(){
        
        //Toma el scrollView horizontal que pasa entre pantallas de la vista principal, para poder hacer uso de este.
        //1: Se busca el View en el que se está actualmente, que en este caso es RootPageViewController.
        //2: Se busca en todos sus SubViews, filtrando por los que sean scrollView.
        //3: Cuando encuentre uno, el primero lo va a tratar de convertir a UIScrollView para poder manipularlo.
        
        //guard let scrollView = view.subviews.filter({$0 is UIScrollView}) as? UIScrollView else { return }
        guard let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return }
        scrollView.delegate = self
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
        
        print("Finalizo el swipe de pagina en rootPage: ", finished)
        
        //Busca dentro de los ViewController el TAG, y asignaselo a Index.
        if let index = pageViewController.viewControllers?.first?.view.tag{
            currentIndex = index
            
            delegateRoot?.currentPage(index) //Realiza un llamado a la funcion en otro ViewController. (llama a MainViewController y permite hacer uso del valor que pasa por parametro Index).
        }
    }
}

extension RootPageViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        
        print("StartOffset: \(startOffset)")
    }
    
    //Cuando se haga el swipe horizontal para pasar entre pantallas, se debe saber si es hacia la izquierda o hacia la derecha.
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction = 0 //Scroll stopped
        
        //Permite saber si se va de dercha a izquierda o al reves.
        if startOffset < scrollView.contentOffset.x {
            direction = 1 //Right
            
        }else if startOffset > scrollView.contentOffset.x {
            direction = -1 //Left
        }
        
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / self.view.frame.width
        delegateRoot?.scrollDetails(direction: (direction == 1) ? .goingRight : .goingLeft, percent: percent, index: currentPage)
        
        print("Percent: \(percent)")
        print("Direction: \(direction)")
    }
}
