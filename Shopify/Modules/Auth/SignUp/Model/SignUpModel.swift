//
//  SignUpModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

struct SignUpModel:Codable{
    let customer: SignUp
    
    
}

struct SignUp: Codable{
    var id: Int?
    var email: String?
}
