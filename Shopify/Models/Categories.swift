//
//  Categories.swift
//  Shopify
//
//  Created by Mac on 23/02/2024.
//

import Foundation

struct CustomCollections : Codable{
    let customCollections : [CustomCollection]
}

struct CustomCollection : Codable{
    let id : Int
    let title : String
    let image : CollectionImage
}
