//
//  OrdersScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

protocol OrderSummaryScreenViewModelProtocol{
    func fetchOrder(orderId:Int?)
    func checkReachability()->Bool
}

class OrderSummaryScreenViewModel : OrderSummaryScreenViewModelProtocol{
    let reachability = NetworkReachability.networkReachability
    let network : NetworkManagerProtocol?
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    var bindOrder : ()->() = {}
    var order : Order?{
        didSet{
            bindOrder()
        }
    }
    
    func fetchOrder(orderId:Int?) {
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + String(orderId ?? 0) + APIHandler.APICompletions.json.rawValue
        
        network?.fetch(url: url, type: Order.self, completionHandler: {[weak self] result in
            guard let order = result else{
                return
            }
            self?.order = order            
        })
    }
    func checkReachability() -> Bool {
        return reachability.networkStatus
    }
}
