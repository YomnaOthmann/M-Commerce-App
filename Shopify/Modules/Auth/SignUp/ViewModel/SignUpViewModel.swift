//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by Mac on 03/03/2024.
//

import Foundation

class SignUpViewModel{
    let network : NetworkManagerProtocol?
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    func postCustomer(mail:String, completionHandler:@escaping(Bool)->()){
        let firstname = mail.components(separatedBy: "@").first
        let newCustomer = NewCustomer(customer: Customer(email: mail, firstName: firstname, lastName: ""))
        
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        print(url)
        network?.post(url: url, parameters: newCustomer, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                print("created")
                completionHandler(true)
            default:
                completionHandler(false)
                print("failed")
            }
        })
    }
}
