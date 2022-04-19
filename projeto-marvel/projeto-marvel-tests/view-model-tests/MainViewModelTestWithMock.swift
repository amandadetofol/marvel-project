//
//  MainViewModelTest.swift
//  UnitTest
//
//  Created by c94292a on 14/01/22.
//

import XCTest
@testable import projeto_marvel

class MainViewModelTestWithMock : XCTestCase {
    
    var sut : MainViewModel?
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_If_View_Model_Is_Searching_Heroes_In_Api(){
        
        sut = MainViewModel(myApi: EmptyMockForNameSearch(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.searchForHeroInApi(heroName: "Hulk", newApi: EmptyMockForNameSearch())
       
        guard let qtd = sut?.heroesDataSource.count else {return}
        guard let addToViewDidNotFoundHeroesLabel = sut?.view?.countAddToViewDidNotFoundHeroesLabel else {return}
        guard let reloadOtherHeroesCollectionView = sut?.view?.countReloadOtherHeroesCollectionView else {return}
        guard let removeFromSuperviewDidNotFoundHeroesLabel = sut?.view?.countRemoveFromSuperviewDidNotFoundHeroesLabel else {return}
        
  
        XCTAssertEqual(addToViewDidNotFoundHeroesLabel , 0)
        XCTAssertEqual(reloadOtherHeroesCollectionView, 1) 
        XCTAssertEqual(removeFromSuperviewDidNotFoundHeroesLabel, 1)
        
        XCTAssertTrue(qtd > 0)
        XCTAssertEqual(sut?.heroesDataSource[0].name, "Hulk")
    }
    
    
   
    func tests_If_ViewModel_Is_Searching_Heroes_In_Api_When_Hero_Not_Found(){
        sut = MainViewModel(myApi: EmptyMockForNameSearh_WhenHeroNotFound(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.searchForHeroInApi(heroName: "Hulk", newApi: EmptyMockForNameSearh_WhenHeroNotFound())
        
        guard let qtd = sut?.heroesDataSource.count else {return}
        guard let addToViewDidNotFoundHeroesLabel = sut?.view?.countAddToViewDidNotFoundHeroesLabel else {return}
        guard let reloadOtherHeroesCollectionView = sut?.view?.countReloadOtherHeroesCollectionView else {return}
        guard let removeFromSuperviewDidNotFoundHeroesLabel = sut?.view?.countRemoveFromSuperviewDidNotFoundHeroesLabel else {return}
        
        XCTAssertTrue(qtd == 0)
        
        XCTAssertEqual(addToViewDidNotFoundHeroesLabel , 1)
        XCTAssertEqual(reloadOtherHeroesCollectionView, 0)
        XCTAssertEqual(removeFromSuperviewDidNotFoundHeroesLabel, 0)
    }
    
    func tests_If_ViewModel_Is_Returning_Error_When_Searching_Heroes_When_Api_Returns_Error(){
       
        sut = MainViewModel(myApi: ApiFailureMock(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.searchForHeroInApi(heroName: "Hulk", newApi: ApiFailureMock())
        
        guard let error = sut?.error  else {return}
        guard let addToViewDidNotFoundHeroesLabel = sut?.view?.countAddToViewDidNotFoundHeroesLabel else {return}
        guard let reloadOtherHeroesCollectionView = sut?.view?.countReloadOtherHeroesCollectionView else {return}
        guard let removeFromSuperviewDidNotFoundHeroesLabel = sut?.view?.countRemoveFromSuperviewDidNotFoundHeroesLabel else {return}
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error as! MarvelApiError, MarvelApiError.emptyArray)
        
        XCTAssertEqual(addToViewDidNotFoundHeroesLabel , 0)
        XCTAssertEqual(reloadOtherHeroesCollectionView, 0)
        XCTAssertEqual(removeFromSuperviewDidNotFoundHeroesLabel, 0)
        
    }
    

    func test_If_ViewModel_Is_Bringing_More_Heroes_From_Api(){
        
        sut = MainViewModel(myApi: EmptyMockForNormalApiCalls(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.loadMoreDataFromApi()
        
        guard let qtd = sut?.heroesDataSource.count else {return}
        guard let reloadOtherHeroes = sut?.view?.countReloadOtherHeroesCollectionView else {return}
        guard let hideLoadingIcon = sut?.view?.countHideLoadingIcon else {return}
        
        XCTAssertTrue(qtd == 20)
        
        XCTAssertEqual(reloadOtherHeroes, 1)
        XCTAssertEqual(hideLoadingIcon, 1)
    }
    
    func tests_If_ViewModel_Is_Returning_Error_When_Bringing_More_Heroes_When_Api_Is_Returning_An_Error(){
        
        sut = MainViewModel(myApi: ApiFailureMock(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.loadMoreDataFromApi()
        
        guard let error = sut?.error  else {return}
        guard let showAlert = sut?.view?.countShowAlert else {return}
        guard let hideLoadingIcon = sut?.view?.countHideLoadingIcon else {return}
        
        XCTAssertEqual(hideLoadingIcon, 1)
        XCTAssertEqual(showAlert, 1)
        
        XCTAssertNotNil(error)
        XCTAssertEqual(error as! MarvelApiError, MarvelApiError.emptyArray)
    }
    

    func test_If_ViewModel_Is_Making_The_Fisrt_Api_Call(){
        
        sut = MainViewModel(myApi: EmptyMockForNormalApiCalls(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.loadDataFromApiInFirstCall()
        
        guard let qtdHorizontalArray = sut?.firstFiveHeroes.count else {return}
        guard let qtdVerticalArray = sut?.heroesDataSource.count else {return}
        
        XCTAssertEqual(qtdHorizontalArray, 5)
        XCTAssertEqual(qtdVerticalArray, 15)
    }
    
    func tests_If_ViewModel_Is_Returning_Error_When_Is_Making_The_Fisrt_Api_Call_And_Api_Returns_Error(){
        
        sut = MainViewModel(myApi: ApiFailureMock(),
                            coreDataController: CoreDataController(),
                            view: MainViewControllerMock()
                            , analyticsController: AnalytcsMock())
        
        sut?.loadDataFromApiInFirstCall()
        
        guard let error = sut?.error  else {return}
        guard let showAlert = sut?.view?.countShowAlert else {return}
        
        XCTAssertNotNil(error)
        XCTAssertEqual(showAlert, 1)
        XCTAssertEqual(error as! MarvelApiError, MarvelApiError.emptyArray)
        
    }
    
    func tests_If_ViewModel_Is_Loading_Data_From_CoreData(){
        
        sut = MainViewModel(myApi: EmptyMockForNormalApiCalls(),
                            coreDataController: DataBaseMock(),
                            view: MainViewControllerMock(),
                            analyticsController: AnalytcsMock())
        
        sut?.loadDataFromCoreData()
        
        guard let qtdHorizontalArray = sut?.firstFiveHeroes.count else {return}
        guard let qtdVerticalArray = sut?.heroesDataSource.count else {return}
        
        XCTAssertTrue(qtdHorizontalArray == 5 )
        XCTAssertTrue(qtdVerticalArray == 15)
    }

}
