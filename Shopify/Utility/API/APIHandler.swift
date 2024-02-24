//
//  APIHandler.swift
//  Shopify
//
//  Created by Mac on 21/02/2024.
//

import Foundation

class APIHandler{
    
    static let baseUrl : String = "https://e68611fa195924ce2d11aa1909193f1b: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@q2-23-24-ios-sv-team1.myshopify.com/admin/api/2024-01"

    enum APIEndPoints :String{
        case products = "/products"
        case orders = "/orders"
        case priceRule = "/price_rules"
        case discountCode = "/discount_codes"
        case count = "/count"
        case collections = "/custom_collections"
        case smartCollection = "/smart_collections"
        case customers = "/customers"
        case address = "/addresses"
    }
    enum APICompletions :String{
        case json = ".json"
    }
}
