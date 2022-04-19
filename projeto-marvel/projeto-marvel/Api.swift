//
//  Api.swift
//  projeto-marvel
//
//  Created by c94292a on 26/11/21.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import UIKit
import CoreData
import Network

struct API {
    let apiClientProtocol : ApiClientProtocol
    func getDados(url : String, completion: @escaping (Character?, Error?) -> Void){
        apiClientProtocol.execute(url: url) { char, error in
            if let result = char {
                completion(result, nil)
            } else{
                completion(nil, error)
            }
        }
    }
}



class RealApiCall : ApiClientProtocol{
    
    var requisicao : Bool = false
    let coreDataController = CoreDataController()
    let baseURL = "http://gateway.marvel.com"
    let path = "v1/public/characters"
    let publicKey = Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String
    let privateKey = Bundle.main.object(forInfoDictionaryKey: "privateKey") as! String
    let ts = Int(Date().timeIntervalSince1970)
    
    func url()->String{
        let content = String(ts) + privateKey + publicKey
        let hash = MD5(string: content)
        return baseURL + "/" + path + "?" + "&offset=\(self.offset)" + "&ts=\(ts)" + "&apikey=\(publicKey)" + "&hash=\(hash)"
    }
    
    func urlSearchByName(name:String) ->String{
        let content = String(ts) + privateKey + publicKey
        let hash = MD5(string: content)
        return baseURL + "/" + path + "?" + "nameStartsWith=\(name)" + "&ts=\(ts)" + "&apikey=\(publicKey)" + "&hash=\(hash)"
    }
    
    lazy var offset : Int = Int(coreDataController.getOffsetFromCoreData())
    var statusCode : Int?
    
    func execute(url : String, completion: @escaping (Character?, Error?) -> Void){
        print(url)
        if let url = URL(string: url) {
            self.requisicao = true
            URLSession.shared.dataTask(with: url) { data, response, error in
                self.requisicao = false
                if let data = data {
                    do{
                        let res = try JSONDecoder().decode(Character.self, from: data)
                        self.statusCode = (response as! HTTPURLResponse).statusCode
                        self.offset += 20
                        self.coreDataController.saveOffsetInCoreData(offset: Double(self.offset))
                        
                        DispatchQueue.main.async { 
                            completion(res, nil)
                        }
                      
                    } catch _ {
                        self.statusCode = (response as! HTTPURLResponse).statusCode
                        DispatchQueue.main.async {
                            completion(nil, MarvelApiError.emptyArray)
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async{
                        completion(nil, MarvelApiError.emptyData)
                    }
                    
                }
            }.resume()
        }
    }
    
    
    func MD5(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
