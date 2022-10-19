//
//  VideosViewController.swift
//  YouTubeClone
//
//  Created by Desarrollo SCOM on 8/6/22.
//

import UIKit

class VideosViewController: UIViewController {
    
    //IBOulets
    @IBOutlet weak var tableViewVideos: UITableView!
    
    //Al usar Self en la declaracion de una variable, hay que usar "lazy" obligatoriamente.
    lazy var presenter = VideosPresenter(delegate: self)
    var videoList: [VideoModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        
        Task{
            await presenter.getVideos()
        }
    }
    
    private func configTableView(){
        
        //Registrar la unica celda que va a tener
        //let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        //tableViewVideos.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
        
        //Registra la celda con la extension que se creo, para eivtar hacer 2 lineas de codigo que estan arriba.
        tableViewVideos.register(cell: VideoCell.self)
        
        tableViewVideos.separatorStyle = .none
        
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource{
    
    //Configura la altura de la celda.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let video = videoList[indexPath.row]
        
        //Refactoring:
        let cell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
        
        //Con el Refactoring, se ahorra esta linea de aqui:
        //guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
        //    return UITableViewCell()
        //}
        
        cell.configCell(model: video)
        
        //Llama al Closure del VideoCell, creando un Closure.
        cell.didTapDotsButton = { [weak self] in //Evitar Retain Cicle (fuga de memoria)
            self?.configButtonSheet() //Se utiliza self porque está dentro de un Closure.
        }
        
        return cell
    }
    
    //Presentar la lista de opciones del boton Dots.
    private func configButtonSheet(){
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext //Quiere decir que se va a presentar sobre la pantalla principal.
        self.present(vc, animated: false)
    }
}

extension VideosViewController: VideosViewProtocol{
    
    func getVideos(videoList: [VideoModel.Item]) {
        self.videoList = videoList
        tableViewVideos.reloadData() //Una vez reciba la informacion, reinicie el TableView para mostrar datos.
    }
}
