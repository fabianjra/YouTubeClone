//
//  PlayVideoViewController.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 23/10/22.
//

import UIKit
import youtube_ios_player_helper

//Para poder utilizar el showError, este viewController debe heredar el BaseViewController (que es donde esta el Alert de showError).
class PlayVideoViewController: BaseViewController {
    
    // MARK: IBOutlets generales:
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    
    // MARK: IBOutlets del TipView:
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var xmarkCloseVideo: UIButton!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var titleVideoLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    
    // MARK: IBOutlets de contraints del PlayerView:
    @IBOutlet weak var playerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    
    
    //Es lazy porque usa self. Al usar el delegate, debe conformar el protocolo, por lo que al final se agrega el extension.
    lazy var presenter = PlayVideoPresenter(delegate: self)
    
    var videoId: String = ""
    
    var goingToBeCollapsed: ((Bool) -> Void)?
    
    //Boton para bajar el FloatingPanel a la parte inferior de la pantalla.
    //Al usar Self en la declaracion de una variable, hay que usar "lazy" obligatoriamente.
    lazy var collapseVideoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.chevronDown, for: .normal)
        button.tintColor = .whiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(collapsedVideoButtonPressed(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad(){
        super.viewDidLoad()

        configTableView()
        configPlayerView()
        loadDataFromApi()
        configCloseButton()
        generalConfig()
        
        //Se oculta el TipView por defecto, ya que no debe aparecer cuando esta a pantalla completa.
        tipView.isHidden = true
    }
    
    //Registra la notificacion de la posicion de la pantalla y el tipView.
    private func generalConfig() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(floatingPannelChanged(notification:)),
                                               name: .viewPosition,
                                               object: nil)
    }
    
    //La notificacion se debe remover cuando se vaya a cerrar la pantalla
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .viewPosition, object: nil)
    }
    
    private func loadDataFromApi(){
        
        //Task en un Closure para llamar a un metodo asincrono.
        //Como esta es una pantalla que se va a estar abriendo y cerrando, se agrega el Weak Self para evitar el Retain Cycle.
        Task { [weak self] in
            await self?.presenter.getVideos(videoId)
        }
    }
    
    private func configPlayerView(){
        
        //Parametros con los que se va a reproducir el vide, por ejemplo autoreproducir, mostrar informacion, etc.
        //Playsinline: Permite darle play directamente al video.
        //controls: Permite mostrar los controles (delante, atras, pantalla completa, etc).
        //autohide: indicates whether the player's video controls will automatically hide after a video begins playing.
        //showinfo: reproductor no muestra información como el título del video o el usuario que lo subió antes de comenzar la reproducción.
        //modestbranding: Este parámetro te permite usar un reproductor de YouTube sin que se muestre un logotipo de YouTube.
        //Documentacion completa: https://developers.google.com/youtube/player_parameters#Parameters
        let playerVars: [AnyHashable: Any] = ["playsinline": 1, "controls": 1, "autohide": 1, "showinfo": 0, "modestbranding": 0]
        
        //El videoId se inyecta desde la pantalla donde se llama esta clase.
        playerView.load(withVideoId: videoId, playerVars: playerVars)
        playerView.delegate = self
    }
    
    private func configTableView(){
        //Delegates
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        //Register TableView
        tableViewVideos.register(cell: VideoHeaderCell.self)
        tableViewVideos.register(cell: VideoFullWidthCell.self)
        
        tableViewVideos.rowHeight = UITableView.automaticDimension
        tableViewVideos.estimatedRowHeight = 69
    }
    
    //Constraints para el boton de minimizar el FloatingPanel, encima de la pantalla de video.
    private func configCloseButton() {
        playerView.addSubview(collapseVideoButton)
        NSLayoutConstraint.activate([
            collapseVideoButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 5),
            collapseVideoButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 5),
            collapseVideoButton.widthAnchor.constraint(equalToConstant: 25),
            collapseVideoButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func collapsedVideoButtonPressed(_ sender: UIButton) {
        guard let goingToBeCollapsed = self.goingToBeCollapsed else { return }
        
        //Si el FloatingPanel se va a ocultar, se pasa la variable true.
        goingToBeCollapsed(true)
    }
    
    @objc private func floatingPannelChanged(notification: Notification) {
        
        guard let value = notification.object as? [String: String] else { return }
        
        if value["position"] == "top" {
            tipView.isHidden = true
            collapseVideoButton.isHidden = false
            
            playerViewHeightConstraint.constant = 225.0 //Tamaño del player cuando este en full screen. Original size.
            playerViewTrailingConstraint.constant = 0.0
            
            view.layoutIfNeeded()
            
            tableViewVideos.isHidden = false
        } else {
            //bottom:
            tipView.isHidden = false // Se muestra el TipView
            collapseVideoButton.isHidden = true
            
            playerViewHeightConstraint.constant = playerViewHeightConstraint.constant * 0.3 //Se hace mas pequeño. 30% del tamaño original.
            playerViewTrailingConstraint.constant = UIScreen.main.bounds.width * 0.7 //Se toma solamente el 70% de la pantalla y se lo asigna al tamaño del reproductor.
            
            view.layoutIfNeeded()
            
            // Se oculta el contenido del tableView para que no se vea en minimizado
            tableViewVideos.isHidden = true
        }
    }
    
    // MARK: Botones TipView
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func tipViewButtonPressed(_ sender: UIButton) {
        
    }
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return presenter.relatedVideoList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.relatedVideoList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = presenter.relatedVideoList[indexPath.section]
        
        //Valida si es el Section 0, para configurar la celda del Header (donde sale la info del video, channel y comentarios).
        if indexPath.section == 0{
            guard let video = item[indexPath.row] as? VideoModel.Item else{ return UITableViewCell()}
            
            let videoHeaderCell = tableView.dequeueReusableCell(for: VideoHeaderCell.self, for: indexPath)
            videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel)
            videoHeaderCell.selectionStyle = .none
            return videoHeaderCell
            
        } else {
            
            guard let video = item[indexPath.row] as? VideoModel.Item else{ return UITableViewCell()}
            let videoFullWidthCell = tableView.dequeueReusableCell(for: VideoFullWidthCell.self, for: indexPath)
            videoFullWidthCell.configCell(model: video)
            return videoFullWidthCell
        }
    }
}

extension PlayVideoViewController: YTPlayerViewDelegate {

    //Cuando se abre la pantalla, el video aun no esta disponible, porque debe cargar cuando va al API de Youtube.
    //Este funcion se ejecuta cuando ya el video está listo.
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

extension PlayVideoViewController: PlayVideoViewProtocol {
    
    func getRelatedVideosFinished(){
        print("Respuesta de: getRelatedVideosFinished")
        
        tableViewVideos.reloadData()
    }
}
