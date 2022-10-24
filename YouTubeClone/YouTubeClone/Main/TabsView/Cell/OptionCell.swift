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
    
    //Asigna el color al underline, dependiendo de la variable isSelected.
    override var isSelected: Bool {
        didSet {
            highlightTitle(isSelected ? .whiteColor : .grayColor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(option: String){
        lblTitle.text = option
    }

    func highlightTitle(_ color: UIColor) {
        lblTitle.textColor = color
    }
}
