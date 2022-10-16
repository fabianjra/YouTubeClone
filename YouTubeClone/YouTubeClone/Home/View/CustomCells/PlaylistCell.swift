//
//  PlaylistCell.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 7/10/22.
//

import UIKit
import Kingfisher

class PlaylistCell: UITableViewCell {
    
    //IBOulets
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblVideoCount: UILabel!
    @IBOutlet weak var lblVideoCountOverlay: UILabel!
    @IBOutlet weak var imgShowPlaylistOverlay: UIImageView!
    @IBOutlet weak var dotsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView(){
        selectionStyle = .none //Para que no se muestre la seleccion de la celda al hacerle tap
        
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "whiteColor")
        
        //usar siempre el color de Dark mode. (en este caso, blanco)
        imgShowPlaylistOverlay.overrideUserInterfaceStyle = .dark
        lblVideoCountOverlay.overrideUserInterfaceStyle = .dark
    }
    
    func configCell(model: PlaylistModel.Item){
        
        let imageUrl = model.snippet.thumbnails.medium.url
        
        if let url = URL(string: imageUrl) {
            imgVideo.kf.setImage(with: url)
        }
        
        lblVideoTitle.text = model.snippet.title
        lblVideoCount.text = String(model.contentDetails.itemCount) + " videos"
        lblVideoCountOverlay.text = String(model.contentDetails.itemCount)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
