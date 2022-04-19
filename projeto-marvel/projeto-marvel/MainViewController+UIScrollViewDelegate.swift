//
//  MainViewController+UIScrollViewDelegate.swift
//  projeto-marvel
//
//  Created by c94292a on 22/11/21.
//

import UIKit

extension MainViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = self.otherHeroesCollectionView.contentOffset.y
        let contentHeight = self.otherHeroesCollectionView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height && self.viewModel.myApi?.requisicao == false && self.viewModel.isFilteringHeroes==false {
            self.viewModel.loadMoreDataFromApi()
        }
    }
}
