//
//  CharacterCollectionViewCell.swift
//  projeto-marvel
//
//  Created by c94292a on 18/11/21.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet var heroImageview: UIImageView!
    @IBOutlet weak var heroLabelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = CAGradientLayer()
        gradient.frame = heroImageview.bounds
        let startColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        heroImageview.layer.insertSublayer(gradient, at: 0)
        heroImageview.layer.cornerRadius = 15
        heroImageview.clipsToBounds = true
        heroLabelName.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
