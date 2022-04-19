//
//  MainViewControllerProtocol.swift
//  projeto-marvel
//
//  Created by c94292a on 13/01/22.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {

    var countReloadFirstFiveCollectionView : Int  {get set}
    var countReloadOtherHeroesCollectionView : Int  {get set}
    var countShowAlert : Int   {get set}
    var countShowLoadingIcon : Int  {get set}
    var countHideLoadingIcon : Int  {get set}
    var countAddToViewDidNotFoundHeroesLabel : Int  {get set}
    var countRemoveFromSuperviewDidNotFoundHeroesLabel : Int  {get set}
    
    func reloadFirstFiveCollectionView()
    func reloadOtherHeroesCollectionView()
    func reloadData()
    func showAlert(message:String)
    func hideLoadingIcon()
    func showLoadingIcon()
    func addToViewDidNotFoundHeroesLabel()
    func removeFromSuperviewDidNotFoundHeroesLabel()
}

protocol MainViewModelSearchProtocol{
    func searchForHeroInApi(heroName:String)
}

