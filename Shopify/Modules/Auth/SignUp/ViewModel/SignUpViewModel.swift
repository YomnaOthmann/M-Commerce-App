//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation
import FirebaseAuth
import Alamofire

class SignUpViewModel{
    func createAccount (email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                print("Sign-up error: \(error.localizedDescription)")
                return
            }
            if let result = authResult {
                self.create(email: email, password: password) { result in
                    switch result{
                    case .success(let customer):
                        print("debug2 \(customer)")
                        
                        
                    case .failure(let error):
                        print(error)
                        
                        
                    }
                }
            }
        }
    }
    
    func create(email: String, password: String,completion:@escaping (Result<SignUpModel, Error>) -> Void){
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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",
            "Content-Type": "application/json"]
        let param: [String: Any]  =
        [
            "customer": [
                "email": "\(email)",
                "password": "\(password)",
                "password_confirmation": "\(password)",
                "send_email_welcome": true
            ]
        ] as [String: Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: param){
            print(jsonData)
            AF.request(BaseUrl.createCustomer.enpoint, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
          
                    do {
               
                        let jsonData = try JSONDecoder().decode(SignUpModel.self, from: data)
                
                        let customerId = jsonData.customer.id
                        
                        UserDefaults.standard.set(customerId, forKey: "customerID")
                        completion(.success(jsonData))

                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else{
            print("Error")
        }
        

        
    }
    
    func getCustomerId(email: String, completion: @escaping (Result<LoginModel, Error>) -> Void) {
        let apiUrl = BaseUrl.createCustomer.enpoint
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
   
        AF.request(apiUrl, method: .get, headers: header).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
       
                do {
           
                    let jsonData = try JSONDecoder().decode(LoginModel.self, from: data)
           
                    for customer in jsonData.customers {
                        if(customer.email == email){
                            let customerId = customer.id
                            // Save the ID to UserDefaults
                            UserDefaults.standard.set(customerId, forKey: "customerID")
                            UserDefaults.standard.set(false, forKey: "USD")
                            print("\(customerId)")
                            break
                        }
                    }
                   
                    completion(.success(jsonData))

                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
