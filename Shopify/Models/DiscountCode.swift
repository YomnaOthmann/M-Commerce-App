//
//  DiscountCode.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 23/02/2024.
//

import Foundation

// MARK: - DiscountCodes
struct DiscountCodes: Codable {
    let discountCodes: [DiscountCode]?

    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

// MARK: - DiscountCode
struct DiscountCode: Codable {
    let id, priceRuleID: Int?
    let code: String?
    let usageCount: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
