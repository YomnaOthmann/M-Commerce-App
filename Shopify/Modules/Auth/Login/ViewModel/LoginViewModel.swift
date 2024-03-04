//
//  LoginViewModel.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate{
    func didLogin()
    func failedToLogin()
    func didRetrieveCustomer()
}

class LoginViewModel{
    
    let network : NetworkManagerProtocol?
    let defaults = UserDefaults.standard
    var delegate : LoginViewModelDelegate?
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    
    func fetchCustomer(mail:String){
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        network?.fetch(url: url, type: Customers.self, completionHandler: { [weak self] result in
            
            guard let customers = result else{
                return
            }
            let customer = customers.customers?.filter({
                $0.email == mail
            }).first
            if customer != nil{
                self?.delegate?.didRetrieveCustomer()
                self?.defaults.set(customer?.id, forKey: "customerId")
                
            }
        })
    }
    
    func loginUsingFirebase(email:String, password:String, completionHandler:((AuthDataResult?,Error?)->Void)? = nil){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
            guard let self = self else{
                return
            }
            guard error == nil else{
                delegate?.failedToLogin()
                completionHandler?(nil,error)
                return
            }
            delegate?.didLogin()
            completionHandler?(result, nil)
        }
    }
}
