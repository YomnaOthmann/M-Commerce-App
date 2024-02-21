//
//  NetworkReachability.swift
//  Shopify
//
//  Created by Mac on 20/02/2024.
//

import Foundation
import Network

class NetworkReachability{
    
    static let networkReachability = NetworkReachability()
    
    var monitor = NWPathMonitor()
    
    var monitorQueue = DispatchQueue(label: "network")
    var networkStatus : Bool = false

    private init(){
        monitor.start(queue: monitorQueue)
        
        monitor.pathUpdateHandler = {[weak self] path in
            
            self?.networkStatus = (path.status == .satisfied)
            
        }
  
    }
}
