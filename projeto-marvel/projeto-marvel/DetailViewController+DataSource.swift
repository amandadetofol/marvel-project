//
//  DetailViewController+DataSource.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//


import UIKit
import Kingfisher

extension DetailViewController : UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.commonCellReusableId)
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = cell.textLabel?.text
        cell.accessibilityTraits = .staticText
        
        self.configureNormalCell(cell: cell)
        
        switch indexPath.row {
            
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as? HeroTableViewCell)
            if let path = hero?.thumbnail?.path,let imageextension = hero?.thumbnail?.thumbnailExtension{
                let url = "\(path)/standard_fantastic.\(imageextension)"
                self.configureImageCell(cell: cell!, url: url)
            } else {
                let image = UIImage(named: "placeholder")
                cell?.image.image = image
            }
        case 1:
            self.configureNameCell(name: hero?.name ?? "Hero", cell: cell)
        case 2:
            cell.textLabel?.text = hero?.description
        case 3:
            guard let comicItens = hero?.comics?.items else {return cell}
            self.configureSerieItemCell(comicItens: comicItens, cell: cell)
        case 4:
            guard let comicItens = hero?.series?.items else {return cell}
            self.configureComicItemCell(comicItens: comicItens, cell: cell)
        case 5:
            self.configureFakeButtonCell(cell: cell)
         
        default:
            return cell
        }
        
        return cell
    }
    
    func configureImageCell(cell:HeroTableViewCell, url:String){
        let heroUrlImage = URL(string: url)
        cell.image.kf.setImage(with: heroUrlImage,
                               placeholder: UIImage(named: "placeholder"),
                               options: [
                                .transition(ImageTransition.fade(2.0)),
                                .cacheOriginalImage
                                
                               ],
                               progressBlock: nil,
                               completionHandler: nil)
    }
    
    func configureFakeButtonCell(cell:UITableViewCell)->(){
        cell.backgroundColor = UIColor.redMarvel
        cell.textLabel?.backgroundColor = UIColor.redMarvel
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.textLabel?.text = "MORE INFO ⩔ "
        cell.textLabel?.textAlignment = .center
        
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "More informations"
        cell.accessibilityHint = "Click for more informations about this hero!"
        cell.accessibilityTraits.insert(.button)
    }
    
    func configureSerieItemCell(comicItens:[ComicsItem], cell:UITableViewCell)->(){
        cell.textLabel?.text = "😔 Sorry, we did not found comics for this hero! Check more infos clicking on the button."
        guard let returned = hero?.comics?.returned else {return}
        if comicItens.count > 0{
            var names = """
                        """
            
            for n in comicItens{
                if let name=n.name {
                    names.append("⩔ \(name)\n" )
                }
            }
            
            cell.textLabel?.text =
                """
                📕 \(returned) COMICS
                \(String(describing: names))
                """
            
        }
    }
    
    func configureComicItemCell(comicItens:[ComicsItem], cell:UITableViewCell)->(){
        cell.textLabel?.text = "😔 Sorry, we did not found series for this hero! Check more infos clicking on the button."
        guard let returned = hero?.series?.returned else {return}
        
        if comicItens.count > 0{
            var names = """
                            """
            
            for n in comicItens{
                if let name=n.name {
                    names.append("⩔ \(name)\n" )
                }
            }
            
            cell.textLabel?.text =
                    """
                    🎬 \(returned) SERIES
                    \(String(describing: names))
                    """
        }
    }
    
    func configureNameCell(name:String, cell:UITableViewCell)-> (){
        cell.textLabel?.text = name
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func configureNormalCell(cell: UITableViewCell)->(){
        cell.backgroundColor = UIColor.blackMarvel
        cell.textLabel?.backgroundColor = UIColor.blackMarvel
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
    }
}

