//
//  MainViewController+DataSource.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//

import UIKit
import Kingfisher

extension MainViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstFiveHeroesCollectionView {
            return self.viewModel.firstFiveHeroes.count
        }
        return self.viewModel.heroesDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CharacterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaCustomizada", for: indexPath) as! CharacterCollectionViewCell
        
      
        
        if collectionView == firstFiveHeroesCollectionView{
            let hero = self.viewModel.firstFiveHeroes[indexPath.row]
            if let path = hero.thumbnail?.path,let imageextension = hero.thumbnail?.thumbnailExtension{
                let url = "\(path)/standard_fantastic.\(imageextension)"
                let heroUrlImage = URL(string: url)
                cell.heroImageview.kf.setImage(with: heroUrlImage,
                                               placeholder: UIImage(named: "placeholder"),
                                                            options: [
                                                                .transition(ImageTransition.fade(2.0)),
                                                                .cacheOriginalImage

                                                            ],
                                                            progressBlock: nil,
                                                            completionHandler: nil)
            } else {
                let image = UIImage(named: "placeholder")
                cell.heroImageview.image = image
                cell.heroImageview.clipsToBounds = true
            }
            cell.heroLabelName.text = hero.name
            configureCellAccessibility(cell: cell, heroName: hero.name ?? "Hero", current: indexPath.row+1, total:5)

            return cell
        }
        
        
        
        let hero = self.viewModel.heroesDataSource[indexPath.row]
        if let path = hero.thumbnail?.path,let imageextension = hero.thumbnail?.thumbnailExtension{
            let url = "\(path)/standard_fantastic.\(imageextension)"
            let heroUrlImage = URL(string: url)
            cell.heroImageview.kf.setImage(with: heroUrlImage,
                                           placeholder: UIImage(named: "placeholder"),
                                                        options: [
                                                            .transition(ImageTransition.fade(2.0)),
                                                            .cacheOriginalImage

                                                        ],
                                                        progressBlock: nil,
                                                        completionHandler: nil)
        } else {
            let image = UIImage(named: "placeholder")
            cell.heroImageview.image = image
            cell.heroImageview.clipsToBounds = true
        }
        cell.heroLabelName.text = hero.name
        configureCellAccessibility(cell: cell, heroName: hero.name ?? "Hero", current: indexPath.row+1, total: viewModel.heroesDataSource.count)
        return cell
    }
    
    func configureCellAccessibility(cell:CharacterCollectionViewCell, heroName:String, current:Int, total:Int){
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "\(heroName). Hero\(current) of \(total)."
        cell.accessibilityHint = "Click to check more informations about \(heroName)."
        cell.accessibilityTraits.insert(.button)
    }
    
}
