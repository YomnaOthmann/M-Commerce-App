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
}
