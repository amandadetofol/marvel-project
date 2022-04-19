//
//  AnalyticsManagerProtocol.swift
//  projeto-marvel
//
//  Created by c94292a on 01/02/22.
//

import Foundation

protocol AnalyticsManagerProtocol{
    func setUserIdAndUserProperties(id:String, property:String, value:String)
    func setEventForSelectedHero(heroName:String)
    func setScreenEvent(screenName:String, screenClass:String, parameters: [String:Any]?)
}
