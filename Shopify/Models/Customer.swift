//
//  Customer.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 23/02/2024.
//

import Foundation

// MARK: - Customers
struct Customers: Codable {
    
    let customers: [Customer]?
    
    enum CodingKeys: String, CodingKey {
        case customers
    }

}

// MARK: - Customer
struct Customer: Codable {
    
    let id: Int?
    let email: String?
    let createdAt, updatedAt: String?
    let firstName, lastName: String?
    let ordersCount: Int?
    let state, totalSpent: String?
    let lastOrderID: Int?
    let verifiedEmail: Bool?
    let taxExempt: Bool?
    let tags, lastOrderName, currency, phone: String?
    let addresses: [Address]?
    let emailMarketingConsent, smsMarketingConsent: MarketingConsent?
    let adminGraphqlAPIID: String?
    let defaultAddress: Address?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

// MARK: - MarketingConsent
struct MarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
    let consentCollectedFrom: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}

