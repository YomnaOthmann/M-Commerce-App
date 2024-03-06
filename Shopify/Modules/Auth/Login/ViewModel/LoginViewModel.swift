//
//  LoginViewModel.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import Foundation

protocol LoginViewModelDelegate{
    func failedToLogin()
    func didRetrieveCustomer(customer:Customer)
}

class LoginViewModel{
    
    let network : NetworkManagerProtocol?
    let defaults = UserDefaults.standard
    var delegate : LoginViewModelDelegate?
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    
    func fetchCustomer(mail:String, password:String, completionHandler:((Customer?)->Void)? = nil){
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        network?.fetch(url: url, type: Customers.self, completionHandler: { [weak self] result in
            
            guard let customers = result else{
                self?.delegate?.failedToLogin()
                return
            }
            guard let customer = customers.customers?.filter({
                $0.email == mail && $0.tags == password
            }).first else{
                completionHandler?(nil)
                self?.delegate?.failedToLogin()
                return
            }
            completionHandler?(customer)
            let customerData = try? JSONEncoder().encode(customer)
            self?.defaults.set(customerData, forKey: "customer")
                self?.delegate?.didRetrieveCustomer(customer: customer)
        })
    }
    
}
