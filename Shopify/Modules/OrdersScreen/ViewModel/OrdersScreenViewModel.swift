//
//  OrdersScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

protocol OrdersScreenViewModelProtocol{
    func fetchOrders()
    func checkReachability()->Bool
}

class OrdersScreenViewModel : OrdersScreenViewModelProtocol{
    let reachability = NetworkReachability.networkReachability
    let network : NetworkManagerProtocol?
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    var bindOrders : ()->() = {}
    var orders : [Order]?{
        didSet{
            bindOrders()
        }
    }
    
    func fetchOrders() {
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + APIHandler.APICompletions.json.rawValue

        network?.fetch(url: url, type: Orders.self, completionHandler: {[weak self] result in
            guard let orders = result else{
                return
            }
            self?.orders = orders.orders
            print(orders.orders[0].lineItems.count)
        })
    }
    func checkReachability() -> Bool {
        return reachability.networkStatus
    }
}
