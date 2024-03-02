//
//  Orders.swift
//  Shopify
//
//  Created by Mac on 22/02/2024.
//

import Foundation

struct Orders : Codable{
    let orders: [Order]
}
struct NewOrder : Codable{
    let order : Order
}

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let confirmed: Bool?
    let createdAt: String?
    let currency: String?
    let currentTotalDiscounts: String?
    let currentTotalPrice: String?
    let financialStatus: FinancialStatus
    let name: String?
    let number, orderNumber: Int?
    let processedAt: String?
    let subtotalPrice: String?
    let token, totalDiscounts: String?
    let totalLineItemsPrice: String?
    let totalPrice: String?
    let customer: Customer?
    let lineItems: [LineItem]
    let shippingAddress: Address?
    let taxLines : [TaxLine]?

    init(id: Int? = nil, confirmed: Bool? = nil, createdAt: String? = nil, currency: String? = nil, currentTotalDiscounts: String? = nil, currentTotalPrice: String? = nil, financialStatus: FinancialStatus, name: String? = nil, number: Int? = nil, orderNumber: Int? = nil, processedAt: String? = nil, subtotalPrice: String? = nil, token: String? = nil, totalDiscounts: String? = nil, totalLineItemsPrice: String? = nil, totalPrice: String? = nil, customer: Customer? = nil, lineItems: [LineItem], shippingAddress: Address? = nil, taxLines: [TaxLine]? = nil) {
        self.id = id
        self.confirmed = confirmed
        self.createdAt = createdAt
        self.currency = currency
        self.currentTotalDiscounts = currentTotalDiscounts
        self.currentTotalPrice = currentTotalPrice
        self.financialStatus = financialStatus
        self.name = name
        self.number = number
        self.orderNumber = orderNumber
        self.processedAt = processedAt
        self.subtotalPrice = subtotalPrice
        self.token = token
        self.totalDiscounts = totalDiscounts
        self.totalLineItemsPrice = totalLineItemsPrice
        self.totalPrice = totalPrice
        self.customer = customer
        self.lineItems = lineItems
        self.shippingAddress = shippingAddress
        self.taxLines = taxLines
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case confirmed
        case createdAt = "created_at"
        case currency
        case currentTotalDiscounts = "current_total_discounts"
        case currentTotalPrice = "current_total_price"
        case financialStatus = "financial_status"
        case name
        case number
        case orderNumber = "order_number"
        case processedAt = "processed_at"
        case subtotalPrice = "subtotal_price"
        case token
        case totalDiscounts = "total_discounts"
        case totalLineItemsPrice = "total_line_items_price"
        case totalPrice = "total_price"
        case customer
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case taxLines = "tax_line"
    }
    // MARK: - FinancialStatus

    enum FinancialStatus: String, Codable {
        case paid = "paid"
        case pending = "pending"
        case refunded = "refunded"
    }

}

// MARK: - LineItem
struct LineItem: Codable {
    let id: Int?
    let adminGraphqlAPIID: String?
    let currentQuantity: Int?
    let giftCard: Bool?
    let name, price: String
    let productExists: Bool
    let productID: Int?
    var quantity: Int
    let sku: String?
    let title, totalDiscount: String
    let variantID: Int?
    let variantTitle, vendor: String?
    let taxLines : [TaxLine]
    var properties : [OrderProperty]?



    init(id: Int? = nil, adminGraphqlAPIID: String? = nil, currentQuantity: Int? = nil, giftCard: Bool? = nil, name: String, price: String, productExists: Bool, productID: Int? = nil, quantity: Int, sku: String? = nil, title: String, totalDiscount: String, variantID: Int? = nil, variantTitle: String? = nil, vendor: String? = nil, taxLines: [TaxLine]) {
        self.id = id
        self.adminGraphqlAPIID = adminGraphqlAPIID
        self.currentQuantity = currentQuantity
        self.giftCard = giftCard
        self.name = name
        self.price = price
        self.productExists = productExists
        self.productID = productID
        self.quantity = quantity
        self.sku = sku
        self.title = title
        self.totalDiscount = totalDiscount
        self.variantID = variantID
        self.variantTitle = variantTitle
        self.vendor = vendor
        self.taxLines = taxLines
    }
    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case currentQuantity = "current_quantity"
        case giftCard = "gift_card"
        case name, price
        case productExists = "product_exists"
        case productID = "product_id"
        case quantity
        case sku, title
        case totalDiscount = "total_discount"
        case variantID = "variant_id"
        case variantTitle = "variant_title"
        case vendor
        case taxLines = "tax_lines"
        case properties
    }
}

// MARK: - Set
struct PriceSet: Codable {
    let shopMoney, presentmentMoney: Money

    enum CodingKeys: String, CodingKey {
        case shopMoney = "shop_money"
        case presentmentMoney = "presentment_money"
    }
}

// MARK: - Money
struct Money: Codable {
    let amount: String
    let currencyCode: String

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}

struct TaxLine : Codable{
    let price : String
    let rate : Double?
    let title : String
    let priceSet : PriceSet?
    enum CodingKeys : String, CodingKey{
        case price, rate, title
        case priceSet = "price_set"
    }
    init(price: String, rate: Double? = 0.06, title: String, priceSet: PriceSet? = nil) {
        self.price = price
        self.rate = rate
        self.title = title
        self.priceSet = priceSet
    }
    
}

struct OrderProperty : Codable{
    var name : String
    var value : String
}
