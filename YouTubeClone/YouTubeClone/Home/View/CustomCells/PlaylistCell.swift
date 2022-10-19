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
    
    //Esta clase necesita levantar la vista de opciones para los puntos (dots), pero es un TableViewCell, entonces no puede directamente.
    //Para poder hacer esto, se va a crear un Closure  que le indica a la vista que implementa esta celda, que debe abrir la ventana de opciones de Dots.
    var didTapDotsButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView(){
        selectionStyle = .none //Para que no se muestre la seleccion de la celda al hacerle tap
        
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .whiteColor
        
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
    
    @IBAction func btnDotsTap(_ sender: UIButton) {
        //Se evalua el Closure opcional, con Safe Unwrap:
        if let tap = didTapDotsButton {
            tap() //Devuelve la informacion a quien implemente el Closure que esta afuera: "var didTapDotButton: (()->void)?"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
