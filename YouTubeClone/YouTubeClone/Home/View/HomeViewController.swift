//
//  HomeViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    
    //1: El lazy se utiliza para que no de error, a la hora de pasarle self a la instancia.
    //2: No es necesario psar el provider, porque ya desde el INIT en la calse HomePresenter, se está asignando que clase usar.
    lazy var presenter = HomePresenter(delegate: self)
    
    //Mismos objetos utilizado en HomePresenter, para manejar el objeto con los items.
    //Se crean en variables por separado, para manejar las propias de esta pantalla.
    private var objectList: [[Any]] = []
    private var sectionTitleList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        //Se utiliza await porque el metodo que se llama es Async.
        //Se utiliza Task porque el ViewDidLoad no puede ser Async.
        Task{
            await presenter.getHomeObjects()
        }
    }
    
    func configTableView(){
        
        //Con el refactoring se ahorran todas estas lineas de codigo.
        /*
        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        //Permite usar un header para un Section del tableView, custom desde el archivo "SectionTitleView".
        tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
         */
        
        //Registra las celdas con el refactoring de extension, para evitar tantas lineas de codigo:
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        
        tableViewHome.separatorStyle = .none //Oculta la linea gris separadora de celdas.
        
        //Quita el espacio extra entre el Navigationbar y su paerte inferior.
        //Se resta 15 para quitar el espacio entre el Navigationbar y el top del TableView.
        //Se resta -80: Porque al final de las celdas, ellas llevan un espacio de padding, entonces cuando llegue a la ultima, se le quita ese espacio en blanco.
        tableViewHome.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: -80, right: 0)
    }
    
    //Logica para saber cuando debe ocultar o mostrar el Navigationbar (detecta el swipe en base al ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        }else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    /*
     Ya no se usa porque ahora se esta utilizando el metodo "viewForHeaderInSection" para usar una celda personalizada para asignar al titulo de cada section.
     
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleList[section].description
    }
     */
    
    //Configura la altura de la celda.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Si la celda es videos o PlaylistItems, se utiliza la siguiente altura:
        if indexPath.section == 1 || indexPath.section == 2 {
            return 95.0
        }
        
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Son 4 iteraciones: cuente los objetos por cada seccion.
        return objectList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //De las 4 secciones, selecciona 1 para validar su tipo.
        let item = objectList[indexPath.section]
        
        //Valida si en el index de section, puede convertir a ChannelModel.Item, si puede, realiza la logica.
        if let channel = item as? [ChannelModel.Item] {
            
            //Refactoring:
            let channelCell = tableView.dequeueReusableCell(for: ChannelCell.self, for: indexPath)
            
            //quitado por refactoring:
            /*
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
                return UITableViewCell()
            }
            */
            
            //Configurar celda:
            //A como va iterando, es una sola, entonces la pasa por parametro.
            channelCell.configCell(model: channel[indexPath.row])
            
            return channelCell
            
        }else if let playlistItems = item as? [PlaylistItemModel.Item] {
            let playlistItemsCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
//            guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
//                return UITableViewCell()
//            }
            
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            
            //Llama al Closure del VideoCell, creando un Closure.
            playlistItemsCell.didTapDotsButton = { [weak self] in //Evitar Retain Cicle (fuga de memoria)
                self?.configButtonSheet() //Se utiliza self porque está dentro de un Closure.
            }
            
            return playlistItemsCell
            
        }else if let video = item as? [VideoModel.Item] {
            let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
//            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
//                return UITableViewCell()
//            }
            
            videoCell.configCell(model: video[indexPath.row])
            
            //Llama al Closure del VideoCell, creando un Closure.
            videoCell.didTapDotsButton = { [weak self] in //Evitar Retain Cicle (fuga de memoria)
                self?.configButtonSheet() //Se utiliza self porque está dentro de un Closure.
            }
            
            return videoCell
            
        }else if let playlist = item as? [PlaylistModel.Item] {
            let playlistCell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
//            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
//                return UITableViewCell()
//            }
            
            playlistCell.configCell(model: playlist[indexPath.row])
            
            //Llama al Closure del VideoCell, creando un Closure.
            playlistCell.didTapDotsButton = { [weak self] in //Evitar Retain Cicle (fuga de memoria)
                self?.configButtonSheet() //Se utiliza self porque está dentro de un Closure.
            }
            
            return playlistCell
        }
        
        return UITableViewCell()
    }
    
    //Permite personalizar el Header de un Section, en base a una celda personalizada llamada "SectionTitleView".
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else {
            return nil
        }
        
        //Configura la celda personalizada.
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
    
    //Presentar la lista de opciones del boton Dots.
    private func configButtonSheet(){
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext //Quiere decir que se va a presentar sobre la pantalla principal.
        self.present(vc, animated: false)
    }
}

extension HomeViewController: HomeViewProtocol{
    
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}
