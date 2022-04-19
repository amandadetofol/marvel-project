//
//  AnalyticsController.swift
//  projeto-marvel
//
//  Created by c94292a on 28/01/22.
//

import Foundation
import Firebase

class AnalyticsManager{
    
    var analyticsManager : AnalyticsManagerProtocol
    
    init(){
        self.analyticsManager =  FirebaseAnalyticsManager()
    }
    
    func setUserIdAndUserProperties(id:String,property:String, value:String){
        analyticsManager.setUserIdAndUserProperties(id: id, property:property, value:value)
    }
    
    func setEventForSelectedHero(heroName:String){
        analyticsManager.setEventForSelectedHero(heroName: heroName)
    }
    
    func setScreenEvent(screenName:String, screenClass:String, parameters: [String:Any]?){
        var parameters = parameters
        parameters?[AnalyticsParameterScreenName] = screenName
        parameters?[AnalyticsParameterScreenClass] = screenClass
        analyticsManager.setScreenEvent(screenName: screenName, screenClass: screenClass, parameters: parameters)
    }
}

