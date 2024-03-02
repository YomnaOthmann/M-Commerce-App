//
//  LoginViewModel.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//
import Foundation
import FirebaseAuth
import Alamofire

class LoginViewModel {
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
                        if customer.email == email {
                            let customerId = customer.id
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
    
    func create(email: String, completion: @escaping (Result<SignUpModel, Error>) -> Void) {
        let header: HTTPHeaders = ["X-Shopify-Access-Token": "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",
                                   "Content-Type": "application/json"]
        
        let param: [String: Any] = [
            "customer": [
                "email": "\(email)",
                "password": "",
                "password_confirmation": "",
                "send_email_welcome": true
            ]
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: param) {
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
        } else {
            print("Error")
        }
    }
}
