//
//  Products.swift
//  Shopify
//
//  Created by Mac on 22/02/2024.
//

import Foundation
// MARK: - All Products

struct Products: Codable {
    let products: [Product]
}

struct NewProduct : Codable{
    let product : Product?
}

// MARK: - Product

struct Product: Codable {
    let id: Int
    let title : String
    let description : String
    let vendor: String
    let productType: ProductType
    let createdAt: String
    let updatedAt, publishedAt: String
    let tags : String
    let variants: [ProductVariant]
    let options: [ProductOption]
    let images: [ProductImage]
    let count : Int = 0
    var templateSuffix : String?
    var isFav : Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title
        case description = "body_html"
        case vendor
        case tags
        case productType = "product_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case variants, options, images
        case templateSuffix = "template_suffix"
    }
    // MARK: - Product Type
    enum ProductType: String, Codable {
        case all = "all"
        case accessories = "ACCESSORIES"
        case shoes = "SHOES"
        case tShirts = "T-SHIRTS"
    }

}
// MARK: - Product Image
struct ProductImage: Codable {
    
    let id: Int
    let position : Int
    let productID: Int
    let graphQlID: String
    let width, height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case position = "position"
        case productID = "product_id"
        case graphQlID = "admin_graphql_api_id"
        case width = "width"
        case height = "height"
        case src = "src"
    }
    
}

// MARK: - Product Variant
struct ProductVariant : Codable{
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let option1: String
    let option2: String
    let createdAt, updatedAt: String
    let inventoryQuantity: Int
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case inventoryQuantity = "inventory_quantity"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
    

}

// MARK: - Product Option
struct ProductOption : Codable{
    let id, productID: Int
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}



