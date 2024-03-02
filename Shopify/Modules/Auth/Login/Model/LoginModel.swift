//
//  LoginModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

struct LoginModel:Codable{
    let customers: [SignIn]
}

struct SignIn: Codable{
    var id: Int
    var email: String
}

