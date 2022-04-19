//
//  Character.swift
//  projeto-marvel
//
//  Created by c94292a on 29/11/21.
//

import Foundation

struct Character:  Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Hero]?
}

struct Hero: Codable {
    let id: Int?
    let name : String?
    let description : String?
    let thumbnail: Thumbnail?
    let comics, series: Comics?
   
}

struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

struct Comics: Codable {
    let items: [ComicsItem]?
    let returned: Int?
}

struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

