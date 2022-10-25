//
//  PlayVideoViewController.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 23/10/22.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController {
    
    //IBOulets
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    
    var videoId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        configPlayerView()
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
}

extension PlayVideoViewController: YTPlayerViewDelegate {

    //Cuando se abre la pantalla, el video aun no esta disponible, porque debe cargar cuando va al API de Youtube.
    //Este funcion se ejecuta cuando ya el video está listo.
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
