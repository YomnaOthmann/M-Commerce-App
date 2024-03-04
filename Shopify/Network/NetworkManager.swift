//
//  NetworkManager.swift
//  Shopify
//
//  Created by Mac on 20/02/2024.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol{
    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?)->Void)
    func post(url: String, parameters:Codable, completionHandler: @escaping(Int)->Void)
}
class NetworkManager : NetworkManagerProtocol{
    func fetch<T: Codable>(url: String, type: T.Type, completionHandler: @escaping (T?)->Void){
        
        let url = URL(string: url)
        guard let url = url else{
            completionHandler(nil)
            return
        }
        
        AF.request(url).response { data in
            guard let data = data.data else{
                completionHandler(nil)
                return
            }
            
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result)
                
            }
            catch let error {
                
                completionHandler(nil)
                print(String(describing: error))
                print("error in decoding..")
            }
            
        }
    }
    
    func post(url: String, parameters:Codable, completionHandler: @escaping(Int)->Void){
        let header : HTTPHeaders = [
            "Cookie" :  ""
        ]
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: header).response{ response in
            guard let statusCode = response.response?.statusCode else{
                return
            }
            switch response.result {
            case .success(_):
                guard let data = response.data else{
                    completionHandler(statusCode)
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! Dictionary<String, Any?>
                    print("json \(json)")
                    completionHandler(statusCode)
                }
                catch let error{
                    print(error.localizedDescription)
                }
            case .failure(_):
                completionHandler(statusCode)
            }
        }
    }
    
    
}
