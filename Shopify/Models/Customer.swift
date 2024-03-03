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
    var taxExemptions : [Int]?
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
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
    init(id: Int? = nil, email: String?, createdAt: String? = nil, updatedAt: String? = nil, firstName: String?, lastName: String?, ordersCount: Int? = nil, state: String? = nil, totalSpent: String? = nil, lastOrderID: Int? = nil, verifiedEmail: Bool? = nil, taxExempt: Bool? = nil, tags: String? = nil, lastOrderName: String? = nil, currency: String? = nil, phone: String? = nil, addresses: [Address]? = [], taxExemptions: [Int]? = nil, emailMarketingConsent: MarketingConsent? = nil, smsMarketingConsent: MarketingConsent? = nil, adminGraphqlAPIID: String? = nil, defaultAddress: Address? = nil) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.firstName = firstName
        self.lastName = lastName
        self.ordersCount = ordersCount
        self.state = state
        self.totalSpent = totalSpent
        self.lastOrderID = lastOrderID
        self.verifiedEmail = verifiedEmail
        self.taxExempt = taxExempt
        self.tags = tags
        self.lastOrderName = lastOrderName
        self.currency = currency
        self.phone = phone
        self.addresses = addresses
        self.taxExemptions = taxExemptions
        self.emailMarketingConsent = emailMarketingConsent
        self.smsMarketingConsent = smsMarketingConsent
        self.adminGraphqlAPIID = adminGraphqlAPIID
        self.defaultAddress = defaultAddress
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

struct NewCustomer : Codable {
    let customer : Customer
}



