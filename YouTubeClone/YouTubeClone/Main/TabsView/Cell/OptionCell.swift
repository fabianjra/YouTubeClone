//
//  OptionCell.swift
//  YouTubeClone
//
//  Created by Fabian Josue Rodriguez Alvarez on 19/10/22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    //IBOulets:
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(option: String){
        lblTitle.text = option
    }

}
