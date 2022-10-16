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
        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        //Permite usar un header para un Section del tableView, custom desde el archivo "SectionTitleView".
        tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        
        tableViewHome.separatorStyle = .none //Oculta la linea gris separadora de celdas.
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
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
                return UITableViewCell()
            }
            
            //Configurar celda:
            //A como va iterando, es una sola, entonces la pasa por parametro.
            channelCell.configCell(model: channel[indexPath.row])
            
            return channelCell
            
        }else if let playlistItems = item as? [PlaylistItemModel.Item] {
            guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }
            
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            
            return playlistItemsCell
            
        }else if let video = item as? [VideoModel.Item] {
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }
            
            videoCell.configCell(model: video[indexPath.row])
            
            return videoCell
            
        }else if let playlist = item as? [PlaylistModel.Item] {
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
                return UITableViewCell()
            }
            
            playlistCell.configCell(model: playlist[indexPath.row])
            
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
}

extension HomeViewController: HomeViewProtocol{
    
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}
