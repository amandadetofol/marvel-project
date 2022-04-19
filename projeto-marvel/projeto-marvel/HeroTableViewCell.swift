//
//  HeroTableViewCell.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//

import UIKit

class HeroTableViewCell: UITableViewCell {

    var image = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.blackMarvel
        self.image.frame = CGRect(x: 0, y: 0, width: 415, height: 410)
        self.image.backgroundColor = UIColor.blackMarvel
        
        let gradient = CAGradientLayer()
        gradient.frame = image.bounds
        let startColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        let endColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        image.layer.insertSublayer(gradient, at: 0)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        contentView.addSubview(image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
