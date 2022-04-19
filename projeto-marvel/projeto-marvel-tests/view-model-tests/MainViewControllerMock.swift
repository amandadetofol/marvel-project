//
//  MainViewControllerMock.swift
//  UnitTest
//
//  Created by c94292a on 17/01/22.
//

import Foundation
@testable import projeto_marvel

class MainViewControllerMock : MainViewModelProtocol{
    
    var countReloadFirstFiveCollectionView : Int  = 0
    var countReloadOtherHeroesCollectionView : Int  = 0
    var countShowAlert : Int  = 0
    var countShowLoadingIcon : Int = 0
    var countHideLoadingIcon : Int = 0
    var countAddToViewDidNotFoundHeroesLabel : Int = 0
    var countRemoveFromSuperviewDidNotFoundHeroesLabel : Int = 0
    
    func reloadFirstFiveCollectionView() {
        countReloadFirstFiveCollectionView += 1
    }
    
    func reloadOtherHeroesCollectionView() {
        countReloadOtherHeroesCollectionView += 1
    }
    
    func reloadData() {
        
    }
    
    func showAlert(message: String) {
        countShowAlert += 1
        print(message)
    }
    
    func hideLoadingIcon() {
        countHideLoadingIcon += 1
    }
    
    func showLoadingIcon() {
        countShowLoadingIcon += 1
    }
    
    func addToViewDidNotFoundHeroesLabel() {
        self.countAddToViewDidNotFoundHeroesLabel += 1
    }
    
    func removeFromSuperviewDidNotFoundHeroesLabel() {
        countRemoveFromSuperviewDidNotFoundHeroesLabel += 1
    }
    
}
