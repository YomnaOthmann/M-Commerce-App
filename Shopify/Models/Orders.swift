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

// MARK: - Order
struct Order: Codable {
    let id: Int
    let confirmed: Bool
    let createdAt: String
    let currency: OrderCurrency
    let currentTotalDiscounts: String
    let currentTotalPrice: String
    let financialStatus: FinancialStatus
    let name: String
    let number, orderNumber: Int
    let processedAt: String
    let subtotalPrice: String
    let token, totalDiscounts: String
    let totalLineItemsPrice: String
    let totalPrice: String
    let customer: Customer?
    let lineItems: [LineItem]
    let shippingAddress: Address?

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
    let id: Int
    let adminGraphqlAPIID: String
    let currentQuantity: Int
    let giftCard: Bool
    let name, price: String
    let productExists: Bool
    let productID: Int?
    var quantity: Int
    let sku: String?
    let title, totalDiscount: String
    let variantID: Int?
    let variantTitle, vendor: String?

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
    }
}

// MARK: - Currency
enum OrderCurrency: String, Codable {
    case egp = "EGP"
    case eur = "EUR"
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
    let currencyCode: OrderCurrency

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}

