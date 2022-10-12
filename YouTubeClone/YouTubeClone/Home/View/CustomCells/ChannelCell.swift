//
//  ChannelCell.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 7/10/22.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    //IBOutlets:
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var subscribeLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var subscribersCountLabel: UILabel!
    @IBOutlet weak var channelDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView(){
        //Cambiar el color de la campana, dependiendo de dark mode o light mode.
        bellImage.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellImage.tintColor = UIColor(named: "grayColor")
        
        profileImage.layer.cornerRadius = 51 / 2
    }
    
    func configCell(model: ChannelModel.Item){
        channelTitle.text = model.snippet.title
        
        channelDescriptionLabel.text = model.snippet.snippetDescription
        
        subscribersCountLabel.text = "\(model.statistics?.subscriberCount ?? "0") subscribers - \(model.statistics?.videoCount ?? "0") videos"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
