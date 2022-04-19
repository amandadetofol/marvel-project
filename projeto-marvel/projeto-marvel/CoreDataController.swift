//
//  CoreDataController.swift
//  projeto-marvel
//
//  Created by c94292a on 11/12/21.
//

import Foundation

public class CoreDataController : CoreDataControllerProtocol{
    
    let context = DataBaseController.persistentContainer.viewContext
    
    public func saveOffsetInCoreData(offset : Double){
        let context = DataBaseController.persistentContainer.viewContext
        let newOffset = OffsetData(context: context)
        newOffset.offsetNumber = offset
        DataBaseController.saveContext()
    }
    
    public func getOffsetFromCoreData() -> Double{
        var offset = 0
        do {
            let res : [OffsetData] = try DataBaseController.persistentContainer.viewContext.fetch(OffsetData.fetchRequest())
            if res.count > 0{
                offset = Int(res[res.count-1].offsetNumber)
            }
        } catch {
            print("An error ocurred")
        }
        return Double(offset)
    }
    
    public func getHeroesFromCoreData()->[DataHero]{
        var data : [DataHero] = []
        do {
            data = try DataBaseController.persistentContainer.viewContext.fetch(DataHero.fetchRequest())
        } catch {
            print("An error ocurred")
        }
        return data
        
    }
}
