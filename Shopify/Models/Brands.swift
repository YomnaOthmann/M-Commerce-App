//
//  Brands.swift
//  Shopify
//
//  Created by Mac on 23/02/2024.
//

import Foundation

struct SmartCollections : Codable{
    let smartCollections : [SmartCollection]
    enum CodingKeys : String, CodingKey{
        case smartCollections = "smart_collections"
    }
}

struct SmartCollection : Codable{
    let id : Int
    let title : String
    let image : CollectionImage
}
struct CollectionImage : Codable{
    let width : Int
    let height : Int
    let src : String
}
