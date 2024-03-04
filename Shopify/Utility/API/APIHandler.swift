

import Foundation

class APIHandler{
    
    static let baseUrl : String =
    "https://3c0bcd19f22e76c8f428caaba79bdb3f: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@q2-24-team1.myshopify.com/admin/api/2024-01"


    enum APIEndPoints :String{
        case products = "/products"
        case orders = "/orders"
        case priceRule = "/price_rules"
        case discountCode = "/discount_codes"
        case count = "/count"
        case collections = "/custom_collections"
        case customers = "/customers"
        case address = "/addresses"
        case smartCollection = "/smart_collections"
        case draftOrders = "/draft_orders"
    }
    enum APICompletions :String{
        case json = ".json"
    }
}

enum APIResponseCodes:Int{
    case userExist = 422
    case createdUser = 201
    case badRequest = 400
}
