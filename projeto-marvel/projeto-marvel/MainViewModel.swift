//
//  MainViewModel.swift
//  projeto-marvel
//
//  Created by c94292a on 13/01/22.
//

import Foundation

class MainViewModel {
    
    var analyticsController = AnalyticsManager()
    var view : MainViewModelProtocol?
    var myApi : ApiClientProtocol?
    var coreDataController : CoreDataControllerProtocol?
    var error : Error?
    var isFilteringHeroes : Bool = false
    let context = DataBaseController.persistentContainer.viewContext
    var searchResult : [Hero]?
    var heroesDataSource:[Hero] = []
    var firstFiveHeroes : [Hero] = []
    let heroesSavedInCoreData = UserDefaults.standard.object(forKey: "heroes")
    
    init(myApi : ApiClientProtocol, coreDataController : CoreDataControllerProtocol, view:MainViewModelProtocol){
        self.myApi = myApi
        self.coreDataController = coreDataController
        self.view = view
        analyticsController.setUserIdAndUserProperties(id: "DETda41f4cb2d6a0fc0a8a724cdf684fa7c9553857b", property: "favorite_fruit", value: "morango")
    }
        
    func searchForHeroInApi(heroName:String, newApi:ApiClientProtocol){
        newApi.execute(url: newApi.urlSearchByName(name: heroName)) { character, error in
            
            if (error != nil) {
                self.error = error
            } else {

                guard let heroes = character?.data?.results else {return}
                self.heroesDataSource = heroes
                
                if (self.heroesDataSource.count == 0){
                    self.isFilteringHeroes=false
                    self.view?.addToViewDidNotFoundHeroesLabel()
                } else {
                    self.isFilteringHeroes=false
                    self.view?.reloadOtherHeroesCollectionView()
                    self.view?.removeFromSuperviewDidNotFoundHeroesLabel()
                }
            }
        }
    }
    
    func setDataSource(){
        if self.coreDataController?.getHeroesFromCoreData().count == 0  {
            self.loadDataFromApiInFirstCall()
        } else {
            self.loadDataFromCoreData()
            
        }
    }
    
    func loadMoreDataFromApi() {
        self.view?.showLoadingIcon()
        guard let myApiUrl = self.myApi?.url() else {return}
        self.myApi?.execute(url: myApiUrl) { [weak self] char, error in
            if (error != nil){
                self?.error = error
                self?.view?.showAlert(message: "We could not reach the server! A problem occurred!")
                self?.view?.hideLoadingIcon()
            } else {
                guard let heroes = char?.data?.results  else {return}
                self?.parseApiDataToCoreDataTypeAndSaveInCoreData(heroes: heroes)
                self?.heroesDataSource += heroes
                self?.view?.reloadOtherHeroesCollectionView()
                self?.view?.hideLoadingIcon()

            }
        }
    }
        
    func loadDataFromCoreData() {
        guard let coreDataHeroes : [DataHero] = self.coreDataController?.getHeroesFromCoreData() else {return}
        let heroes : [Hero] = parseCoreDataHeroToScreenHero(coreDataHeroes: coreDataHeroes)
        self.firstFiveHeroes = Array(heroes[0...4])
        self.heroesDataSource = Array(heroes[5..<heroes.count])
        DispatchQueue.main.async {  [weak self] in
            self?.view?.reloadData()
        }
    }
   
    
    func loadDataFromApiInFirstCall(){
        self.coreDataController?.context.processPendingChanges()
        
        myApi?.execute(url: myApi?.url() ?? "" , completion: { [weak self] char, error in
            if let error = error {
                self?.error=error
                self?.view?.showAlert(message: "We could not reach the server! A problem occurred!")
            } else {
                guard let heroes = char?.data?.results else {return}
                self?.parseApiDataToCoreDataTypeAndSaveInCoreData(heroes: heroes)
                self?.firstFiveHeroes = Array(heroes[0...4])
                self?.heroesDataSource = Array(heroes[5..<heroes.count])
                DispatchQueue.main.async {  [weak self] in
                    self?.view?.reloadData()
                }
            }
        })
    }
    
    func parseApiDataToCoreDataTypeAndSaveInCoreData(heroes apiHeroes : [Hero]){
        if apiHeroes.count > 0{
            self.coreDataController?.context.processPendingChanges()
            for hero in apiHeroes{
                self.coreDataController?.context.processPendingChanges()
                if let path = hero.thumbnail?.path, let name = hero.name, let id = hero.id, let description = hero.description, let imageExtension = hero.thumbnail?.thumbnailExtension, let comicsItems = hero.comics?.items, let seriesItems = hero.series?.items{
                    
                    let heroData = DataHero(context: self.context)
                    heroData.id = Double(id)
                    heroData.name = name
                    heroData.heroDescription = description
                    heroData.image = path
                    heroData.imageExtension = imageExtension
                    
                    //comics
                    if comicsItems.count > 0 {
                        
                        var comics : [DataComics] = []
                        for comic in comicsItems{
                            self.coreDataController?.context.processPendingChanges()
                            let comicData = DataComics(context: self.context)
                            comicData.hero = heroData
                            comicData.comicName = comic.name ?? ""
                            comics.append(comicData)
                        }
                        let comicsData = Set(comics) as NSSet
                        heroData.comics = comicsData
                    }
                    //comics
                    
                    //series
                    if seriesItems.count > 0{
                        var series : [DataComics] = []
                        for serie in seriesItems{
                            self.coreDataController?.context.processPendingChanges()
                            let serieData = DataComics(context: self.context)
                            serieData.heroSerie = heroData
                            serieData.comicName = serie.name ?? ""
                            series.append(serieData)
                        }
                        let seriesData = Set(series) as NSSet
                        heroData.series = seriesData
                    }
                    //series
                }
            }
            
            DataBaseController.saveContext()
        }
    }
    
    func parseCoreDataHeroToScreenHero(coreDataHeroes:[DataHero]) -> [Hero]{
        var heroes : [Hero] = []
        for heroData in coreDataHeroes{
            if heroData.name != nil {
                
                var comicsItems : [ComicsItem] = []
                let heroDataComics = heroData.comics?.allObjects as? [DataComics]
                for heroDataComic in heroDataComics!{
                    let c = ComicsItem(resourceURI: "", name: heroDataComic.comicName)
                    comicsItems.append(c)
                }
                let realComics = Comics(items: comicsItems, returned: comicsItems.count)
                
                var seriesItems : [ComicsItem] = []
                let heroDataSeries = heroData.series?.allObjects as? [DataComics]
                for dataSeries in heroDataSeries! {
                    let s = ComicsItem(resourceURI: "", name: dataSeries.comicName)
                    seriesItems.append(s)
                }
                let series = Comics(items: seriesItems, returned: seriesItems.count)
                
                
                let hero = Hero(id: Int(heroData.id), name: heroData.name, description: heroData.heroDescription, thumbnail: Thumbnail(path: heroData.image, thumbnailExtension: heroData.imageExtension ) , comics: realComics, series: series)
                heroes.append(hero)
            }
        }
        return heroes
    }
}
