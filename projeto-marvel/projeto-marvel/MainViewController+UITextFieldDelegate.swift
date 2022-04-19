//
//  MainViewController+UITextFieldDelegate.swift
//  projeto-marvel
//
//  Created by c94292a on 22/11/21.
//

import UIKit
extension MainViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.viewModel.isFilteringHeroes=true
        guard let heroName = textField.text else {return true}
        viewModel.searchForHeroInApi(heroName: heroName, newApi: RealApiCall())
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let textFieldText = textField.text else {
                return
            }
            if !textFieldText.isEmpty{
                viewModel.isFilteringHeroes=true
                viewModel.heroesDataSource = viewModel.heroesDataSource.filter { hero in
                    guard let heroName = hero.name else {return true}
                    return heroName.hasPrefix(textFieldText)
                }

                if viewModel.heroesDataSource.count == 0{
                    self.view.addSubview(self.didNotFoundHeroesLabel)
                }
                self.otherHeroesCollectionView.reloadData()
            } else {
                    viewModel.isFilteringHeroes=false
                    didNotFoundHeroesLabel.removeFromSuperview()
                    viewModel.loadDataFromCoreData()
            }
        }
}
