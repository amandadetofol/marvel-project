//
//  CoreDataProtocol.swift
//  projeto-marvel
//
//  Created by c94292a on 14/01/22.
//

import Foundation
import CoreData

protocol CoreDataControllerProtocol : AnyObject {
    var context: NSManagedObjectContext { get }
    func saveOffsetInCoreData(offset : Double)
    func getOffsetFromCoreData() -> Double
    func getHeroesFromCoreData()->[DataHero]
}
