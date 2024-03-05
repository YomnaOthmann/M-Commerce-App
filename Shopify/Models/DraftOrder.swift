//
//  DraftOrder.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

// MARK: - DraftOrders
struct DraftOrders: Codable {
    let draftOrders: [DraftOrder]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

struct NewDraftOrder: Codable{
    let draftOrder : DraftOrder
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrder: Codable {
    
    let id: Int?
    let note, email: String?
    let taxesIncluded: Bool?
    let currency: String?
    let invoiceSentAt: String?
    let createdAt, updatedAt: String?
    let taxExempt: Bool?
    let completedAt: String?
    let name, status: String?
    let lineItems: [LineItem]?
    let shippingAddress, billingAddress: Address?
    let invoiceURL: String?
    let orderID: Int?
    let shippingLine: ShippingLine?
    let tags: String?
    let totalPrice, subtotalPrice, totalTax: String?
    let presentmentCurrency: String?
    let adminGraphqlAPIID: String?
    let customer: Customer?
    let appliedDiscount : AppliedDiscount?

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case currency
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case name, status
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceURL = "invoice_url"
        case orderID = "order_id"
        case shippingLine = "shipping_line"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case presentmentCurrency = "presentment_currency"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case customer
        case appliedDiscount = "applied_discount"
    }
}


// MARK: - ShippingLine
struct ShippingLine: Codable {
    let title: String
    let custom: Bool
    let handle: String?
    let price: String
}
struct AppliedDiscount:Codable{
    let title : String
    let description : String
    let value : String
    let valueType : String
    let amount : String
}

