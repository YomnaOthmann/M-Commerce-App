//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by Mac on 03/03/2024.
//

import Foundation
import FirebaseAuth

protocol SignUpDelegate{
    func didRegistered(mail:String)
    func didFailToRegister(error:Error?)
}

class SignUpViewModel{
    
    let defaults = UserDefaults.standard
    let network : NetworkManagerProtocol?
    var bindCustomer : ()->() = {}
    var delegate : SignUpDelegate?
    var customer : Customer?{
        didSet{
            bindCustomer()
        }
    }
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    func postCustomer(mail:String, completionHandler:@escaping(Bool,String)->()){
        
        let firstname = mail.components(separatedBy: "@").first?.capitalized
        
        let newCustomer = NewCustomer(customer: Customer(email: mail, firstName: firstname, lastName: ""))
        
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        
        network?.post(url: url, parameters: newCustomer, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                completionHandler(true,"Account Created Successfully")
            case 422:
                completionHandler(false,"This account already exists")
            default:
                completionHandler(false,"Failed to register your account")
            }
        })
    }
    func registerUsingFirebase(email: String, password: String,completionHandler:((Error?)->Void)? = nil){
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            guard let result = result, error == nil else{
                self?.delegate?.didFailToRegister(error: error)
                completionHandler?(error)
                return
            }
            self?.delegate?.didRegistered(mail:email)
            completionHandler?(nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

