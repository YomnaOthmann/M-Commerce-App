//
//  Address.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 23/02/2024.
//

import Foundation

// MARK: - Address

struct AddressPostModel:Codable {
    
    let address:Address?
    enum CodingKeys: String, CodingKey {
        case address = "customer_address"
    }
    
    init(address: Address?) {
        self.address = address
    }
    
}

struct Address: Codable {
    
    let id, customerID: Int?
    let address1, address2, city, province: String?
    let country, zip, phone, name: String?
    let provinceCode, countryCode, countryName: String?
    let addressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}
