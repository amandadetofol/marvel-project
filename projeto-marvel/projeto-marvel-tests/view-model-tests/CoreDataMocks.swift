//
//  CoreDataMocks.swift
//  UnitTest
//
//  Created by c94292a on 17/01/22.
//

import Foundation
import CoreData
@testable import projeto_marvel

class DataBaseMock : CoreDataControllerProtocol {
    var context: NSManagedObjectContext = DataBaseController.persistentContainer.viewContext
   
    func saveOffsetInCoreData(offset: Double) {}
    
    func getOffsetFromCoreData() -> Double {return 0}
    
    func getHeroesFromCoreData() -> [DataHero] {
        let hero = DataHero(context:self.context)
        hero.name = "Hero"
        return Array(repeating: hero, count: 20 )
    }
}
