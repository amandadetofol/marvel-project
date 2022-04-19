//
//  MainViewController+Delegate.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//

import UIKit


extension MainViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.firstFiveHeroesCollectionView{
            let hero : Hero = viewModel.firstFiveHeroes[indexPath.row]
            let detail = DetailViewController()
            detail.hero = hero
            if let heroName = hero.name {
                let heroWithoutSpaces = heroName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                viewModel.analyticsController.setEventForSelectedHero(heroName: heroWithoutSpaces)
            }
            self.show(detail, sender: nil)
        } else {
            let hero : Hero = viewModel.heroesDataSource[indexPath.row]
            let detail = DetailViewController()
            detail.hero = hero
            if let heroName = hero.name {
                let heroWithoutSpaces = heroName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                viewModel.analyticsController.setEventForSelectedHero(heroName: heroWithoutSpaces)
            }
            self.show(detail, sender: nil)
        }
        
        
    }

}

