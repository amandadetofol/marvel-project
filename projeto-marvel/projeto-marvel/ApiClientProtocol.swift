//
//  Api+Protocol.swift
//  projeto-marvel
//
//  Created by c94292a on 03/12/21.
//

import Foundation

protocol ApiClientProtocol {
    var requisicao : Bool {get set}
    func execute(url : String, completion: @escaping (Character?, Error?) -> Void)
    func url()->String
    func urlSearchByName(name:String) ->String
   
}

