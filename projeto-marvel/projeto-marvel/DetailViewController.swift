//
//  DetailViewController.swift
//  projeto-marvel
//
//  Created by c94292a on 19/11/21.
//

import UIKit

class DetailViewController : UIViewController {
    
    let commonCellReusableId = "commonCellReusableId"
    let cellReusableId = "heroTableViewCellId"
    var hero : Hero?
    var detailViewModel = DetailViewModel()
    
    lazy var detailTableView : UITableView =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.detailViewSetUp()
        self.view.addSubview(self.detailTableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        detailViewModel.analyticsController.setScreenEvent(screenName: "Detail Screen", screenClass: "DetailViewController", parameters: [:])
    }
    
    fileprivate func detailViewSetUp(){
        self.detailTableView.dataSource=self
        self.detailTableView.delegate = self
        self.detailTableView.separatorStyle = .none
        self.detailTableView.backgroundColor = UIColor.blackMarvel
        self.detailTableView.register(HeroTableViewCell.self, forCellReuseIdentifier: self.cellReusableId)
        self.detailTableView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        self.detailTableView.contentInset.bottom = 64
    }

    fileprivate func configureNavBar()->(){
        let imageView = UIImageView(image: UIImage(named: "marvel-logo"))
        self.navigationItem.titleView = imageView
        
        self.navigationItem.titleView?.isAccessibilityElement = true
        self.navigationItem.titleView?.accessibilityLabel = "Marvel Logo"
        self.navigationItem.titleView?.accessibilityTraits.insert(.staticText)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
}
