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
//        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + APIHandler.APICompletions.json.rawValue
        let url = "https://e68611fa195924ce2d11aa1909193f1b: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@q2-23-24-ios-sv-team1.myshopify.com/admin/api/2024-01/orders.json"
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
