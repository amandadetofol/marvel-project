//
// ViewController.swift
// Collection
//
// Created by Amanda Detofol Constante on 15/10/21.
//
import UIKit
import Lottie
import CoreData
import CFNetwork



class MainViewController: UIViewController, MainViewModelProtocol {
    
    var countReloadFirstFiveCollectionView: Int = 0
    var countReloadOtherHeroesCollectionView: Int = 0
    var countShowAlert: Int = 0
    var countShowLoadingIcon: Int = 0
    var countHideLoadingIcon: Int = 0
    var countRemoveFromSuperviewDidNotFoundHeroesLabel: Int = 0
    var countAddToViewDidNotFoundHeroesLabel: Int = 0
    
    lazy var viewModel : MainViewModel = MainViewModel(myApi: RealApiCall(),
                                                       coreDataController: CoreDataController(),
                                                       view: self)
    var scrollView : UIScrollView = UIScrollView()
    var firstFiveHeroesCollectionView : UICollectionView!
    var otherHeroesCollectionView : UICollectionView!
  
    lazy var marvelCharactesListlabel : UILabel = {
        let marvelCharactesListlabel = UILabel(frame: CGRect(x: 10, y: 264, width: self.view.bounds.width, height: 40))
        marvelCharactesListlabel.textAlignment = NSTextAlignment.left
        marvelCharactesListlabel.text = "MARVEL CHARACTERS LIST"
        
        marvelCharactesListlabel.font = UIFont.preferredFont(forTextStyle: .body)
        marvelCharactesListlabel.isAccessibilityElement = true
        marvelCharactesListlabel.accessibilityLabel = "Marvel Chatacters List"
        marvelCharactesListlabel.accessibilityTraits = .header
        
        return marvelCharactesListlabel
    }()
    
    lazy var searchBar : UITextField = {
        let searchBar = UITextField(frame: CGRect(x: 24, y: 294, width: self.view.bounds.width-48, height: 40))
        
        let border = CALayer()
        
        let width = CGFloat(1.2)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: searchBar.frame.size.height - width, width: searchBar.frame.size.width*2, height: searchBar.frame.size.height*2)
        border.borderWidth = width
        searchBar.borderStyle = .none
        searchBar.layer.addSublayer(border)
        searchBar.layer.masksToBounds=true
        searchBar.placeholder = "   Search characters"
        searchBar.delegate=self
        searchBar.font = UIFont.preferredFont(forTextStyle: .body)
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityLabel = "Search Bar"
        searchBar.accessibilityHint = "Type hero name to search local storage. Press enter to search the API. The results will be in the group below. "
        searchBar.accessibilityTraits.insert(.searchField)
        return searchBar
    }()
    
    var searchImageView : UIImageView = {
        let searchImageView : UIImageView
        searchImageView  = UIImageView(frame:CGRect(x: 10, y: 304, width: 15, height: 15));
        searchImageView.image = UIImage(named:"search")
        searchImageView.isAccessibilityElement = false
        return searchImageView
    }()
    
    var animationView: AnimationView = {
        var animation = AnimationView(name: "loading")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        
        animation.isAccessibilityElement = true
        animation.accessibilityLabel = "Loading"
        animation.accessibilityTraits.insert(.staticText)
        
        return animation
    }()
    
    lazy var characterLabel : UILabel = {
        let featuredCharactersLabel = UILabel(frame: CGRect(x: 10, y: 24, width: self.view.bounds.width, height: 40))
        featuredCharactersLabel.textAlignment = NSTextAlignment.left
        featuredCharactersLabel.text = "FEATURED CHARACTERS"
        featuredCharactersLabel.font = UIFont.preferredFont(forTextStyle: .body)
        featuredCharactersLabel.isAccessibilityElement = true
        featuredCharactersLabel.accessibilityLabel = "Featured Characters"
        featuredCharactersLabel.accessibilityTraits = .header
        return featuredCharactersLabel
    }()
    
    var didNotFoundHeroesLabel : UILabel = {
        let didNotFoundHeroesLabel = UILabel(frame: CGRect(x: 20, y: 500, width: 350, height: 40))
        didNotFoundHeroesLabel.textAlignment = NSTextAlignment.center
        didNotFoundHeroesLabel.textColor = .gray
        didNotFoundHeroesLabel.text = "SORRY, NO HEROES WITH THIS DESCRIPTION"
        didNotFoundHeroesLabel.font = UIFont.preferredFont(forTextStyle: .body)
        didNotFoundHeroesLabel.isAccessibilityElement = true
        didNotFoundHeroesLabel.accessibilityLabel = "Sorry, no heroes with this description."
        didNotFoundHeroesLabel.accessibilityHint = "Try searching for another hero."
        didNotFoundHeroesLabel.accessibilityTraits.insert(.staticText)
        return didNotFoundHeroesLabel
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setDataSource()
        self.configureNavBar()
        self.addOtherViewItems()
        self.addingCollectionViewLayout()
        self.configureCollectionViewDataSourceAndDelegate()
        self.registerCollectionViewCustomCell()
        self.buildCollectionViewLayoutAndAddToView()
        self.setupLoadingIcon()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.analyticsController.setScreenEvent(screenName: "Main Screen", screenClass: "MainViewController", parameters: [:])
    }
    
    public func showAlert(message alertMessage: String) -> () {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Atention", message: alertMessage, preferredStyle: .alert)
            
            //when the user has no connection with the internet and is using the app for the first time
            let tryAgainButton = UIAlertAction(title: "Try Again", style: .default) { _ in
                self?.viewModel.loadDataFromApiInFirstCall()
            }
            
            let closeButton = UIAlertAction(title: "Close", style: .destructive, handler: nil)
            alert.addAction(tryAgainButton)
            alert.addAction(closeButton)
            self?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    fileprivate func configureCollectionViewDataSourceAndDelegate(){
        otherHeroesCollectionView.dataSource=self
        otherHeroesCollectionView.delegate=self
        firstFiveHeroesCollectionView.dataSource=self
        firstFiveHeroesCollectionView.delegate=self
    }
   
    fileprivate func addingCollectionViewLayout()->(){
        let heroFeaturedLayout = UICollectionViewFlowLayout()
        heroFeaturedLayout.scrollDirection = .horizontal
        heroFeaturedLayout.itemSize = CGSize(width: 160, height:160.0)
       
        
        let marvelAllHeroesFeaturedLayout = UICollectionViewFlowLayout()
        marvelAllHeroesFeaturedLayout.scrollDirection = .vertical
        marvelAllHeroesFeaturedLayout.itemSize = CGSize(width: 160, height:160.0)
     
        firstFiveHeroesCollectionView = UICollectionView(frame:.zero,
                                                                collectionViewLayout: heroFeaturedLayout)
        otherHeroesCollectionView = UICollectionView(frame:.zero,
                                                          collectionViewLayout: marvelAllHeroesFeaturedLayout)
    }
    
    fileprivate func configureNavBar()->(){
        let imageView = UIImageView(image: UIImage(named: "marvel-logo"))
        self.navigationItem.titleView = imageView
    
        self.navigationItem.titleView?.isAccessibilityElement = true
        self.navigationItem.titleView?.accessibilityLabel = "Marvel Logo"
        self.navigationItem.titleView?.accessibilityTraits.insert(.staticText)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    fileprivate func registerCollectionViewCustomCell()->(){
        let nibCelula = UINib(nibName:"CharacterCollectionViewCell", bundle: nil)
        self.firstFiveHeroesCollectionView.register(nibCelula, forCellWithReuseIdentifier: "celulaCustomizada")
        
        self.otherHeroesCollectionView.register(nibCelula, forCellWithReuseIdentifier: "celulaCustomizada")
    }
    
    fileprivate func addOtherViewItems()->(){
        self.view.addSubview(characterLabel)
        self.view.addSubview(marvelCharactesListlabel)
        self.view.addSubview(searchImageView)
        self.view.addSubview(searchBar)
    }
    
    func showLoadingIcon()->(){
        self.animationView.isHidden = false
        self.animationView.play()
    }
    
    func hideLoadingIcon()->(){
        self.animationView.isHidden = true
        self.animationView.stop()
    }
    
    func setupLoadingIcon()->(){
        self.animationView.isHidden = true
        self.animationView.frame = CGRect(x: self.view.bounds.width/2 - 10, y: 720, width: 20, height: 20)
        self.view.addSubview(self.animationView)
        self.animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 20),
            animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            firstFiveHeroesCollectionView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    fileprivate func setTranslatesToFalse()->(){
        self.otherHeroesCollectionView.translatesAutoresizingMaskIntoConstraints=false
        self.firstFiveHeroesCollectionView.translatesAutoresizingMaskIntoConstraints=false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setHeroFeaturedCharactersCollectionViewConstraintsAndAddToView()->(){
        self.view.addSubview(self.firstFiveHeroesCollectionView)
        NSLayoutConstraint.activate([
            firstFiveHeroesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 54),
            firstFiveHeroesCollectionView.heightAnchor.constraint(equalToConstant: 180),
            firstFiveHeroesCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            firstFiveHeroesCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95)
        ])
    }
    
    fileprivate func setScrollViewConstraints()->(){
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 340),
            scrollView.heightAnchor.constraint(equalToConstant: 360),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50 ),
            scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95)
        ])
    }
    
    fileprivate func setmarvelCollectionViewConstraintsAndAddToView()->(){
        
        view.addSubview(self.otherHeroesCollectionView)
        NSLayoutConstraint.activate([
            otherHeroesCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            otherHeroesCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            otherHeroesCollectionView.widthAnchor.constraint(equalToConstant:  335),
            otherHeroesCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            otherHeroesCollectionView.heightAnchor.constraint(equalToConstant: self.view.bounds.width)
            
        ])
    }
    
    fileprivate func buildCollectionViewLayoutAndAddToView()->(){
        self.setTranslatesToFalse()
        self.setHeroFeaturedCharactersCollectionViewConstraintsAndAddToView()
        self.setScrollViewConstraints()
        self.setmarvelCollectionViewConstraintsAndAddToView()
    }
    
    func reloadData(){
        self.firstFiveHeroesCollectionView.reloadData()
        self.otherHeroesCollectionView.reloadData()
    }
    
    func addToViewDidNotFoundHeroesLabel() {
        self.view.addSubview(self.didNotFoundHeroesLabel)
    }
    
    func removeFromSuperviewDidNotFoundHeroesLabel() {
        self.didNotFoundHeroesLabel.removeFromSuperview()
    }
    
    func reloadFirstFiveCollectionView(){
        self.firstFiveHeroesCollectionView.reloadData()
    }
    
    func reloadOtherHeroesCollectionView(){
        self.otherHeroesCollectionView.reloadData()
    }

}

