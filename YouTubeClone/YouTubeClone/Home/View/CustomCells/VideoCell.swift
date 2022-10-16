//
//  VideoCell.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 7/10/22.
//

import UIKit

class VideoCell: UITableViewCell {
    
    //IBOulets:
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var dotsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView(){
        selectionStyle = .none //Para que no se muestre la seleccion de la celda al hacerle tap
    }
    
    //Se recibe Any, porque esta misma celda se esta utiliznado para Videos y PlaylistItem, entonces puede ser cualquiera de los 2.
    func configCell(model: Any){
        
        //Imagen de dots dinamico para dark mode o light mode.
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "whiteColor")
        
        //si esta recibiendo el model de video, realiza esta logica.
        if let video = model as? VideoModel.Item{
            
            //If let, para hacer un "safe unwrap".
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
            }
            
            //como es un opcional, si no trae texto, debe ponerle un vacio.
            videoName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.channelTitle ?? ""
            viewsCount.text = "\(video.statistics?.viewCount ?? "0") views - 3 months ago"
            
            //Si no es un videoModel, es un PlaylistItemModel.
        } else if let playlistItems = model as? PlaylistItemModel.Item {
            
            if let imageUrl = playlistItems.snippet.thumbnails?.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
            }
            
            videoName.text = playlistItems.snippet.title
            channelName.text = playlistItems.snippet.channelTitle
            viewsCount.text = "332 views - 3 months ago"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
