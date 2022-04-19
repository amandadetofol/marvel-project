//
//  FirebaseAnalyticsManager.swift
//  projeto-marvel
//
//  Created by c94292a on 01/02/22.
//

import Foundation
import Firebase

class FirebaseAnalyticsManager: AnalyticsManagerProtocol {
    func setUserIdAndUserProperties(id:String,property:String, value:String){
        Analytics.setUserID(id)
        Analytics.setUserProperty(value, forName: property)
    }
    
    func setEventForSelectedHero(heroName:String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: ["hero_name":heroName])
    }
    
    func setScreenEvent(screenName:String, screenClass:String, parameters: [String:Any]?){
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: parameters)
    }
}
