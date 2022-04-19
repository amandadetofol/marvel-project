//
//  MocksHttpClient.swift
//  UnitTest
//
//  Created by c94292a on 03/12/21.
//

import Foundation
@testable import projeto_marvel

class ApiClientProtocolFakeEmptyData : ApiClientProtocol{
    func urlSearchByName(name: String) -> String {
        return name
    }
    
    var requisicao: Bool = false
    
    func url() -> String {
        return "anyurl"
    }
    
    func execute(url: String, completion: @escaping (Character?, Error?) -> Void) {
        completion(nil, MarvelApiError.emptyData)
    }
}

class ApiClientProtocolFakeEmptyArray : ApiClientProtocol{
    func urlSearchByName(name: String) -> String {
        return name
    }
    
    var requisicao: Bool = false
    
    func execute(url: String, completion: @escaping (Character?, Error?) -> Void) {
        completion(nil, MarvelApiError.emptyArray)
    }
    
    func url() -> String {
        return "anyurl"
    }
}

class ApiClientProtocolSucess : ApiClientProtocol{
    func urlSearchByName(name: String) -> String {
        return name
    }
    
    var requisicao: Bool = false
    
    var statusCode : Int = 0
    
    func url() -> String {
        return "anyurl"
    }
    
    var fakeCharacter = Character(data: DataClass(offset: 0, limit:0, total:0, count:0 , results: [Hero(id: 0, name: "hero", description: "hero", thumbnail: nil, comics: nil, series: nil)]))

    func execute(url: String, completion: @escaping (Character?, Error?) -> Void){
        statusCode = 200
        completion(fakeCharacter, nil)
    }
}

class ApiClientProtocolIsBrigingMoreThenOneItem : ApiClientProtocol{
    func urlSearchByName(name: String) -> String {
        return name
    }
    
    var requisicao: Bool = false
    
    func url() -> String {
        return "anyurl"
    }
    
    func execute(url: String, completion: @escaping (Character?, Error?) -> Void) {
        completion(nil, MarvelApiError.emptyArray)
    }
}

