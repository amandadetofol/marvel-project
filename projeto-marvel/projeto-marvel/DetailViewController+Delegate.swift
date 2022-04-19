//
//  DetailViewController+Delegate.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//

import UIKit

extension DetailViewController : UITableViewDelegate{
    
    func openMarvelUrl(indexPath: IndexPath){
        if indexPath.row == 5 {
            UIApplication.shared.open(NSURL(string: "https://marvel.com")! as URL)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return self.view.bounds.width + 20
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openMarvelUrl(indexPath: indexPath)
    }
}
