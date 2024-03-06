//
//  MeScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import Foundation

class MeScreenViewModel{
    
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
            let customerId = UserDefaults.standard.integer(forKey: "customerId")
            print("id = \(customerId)")
            self?.orders = orders.orders.filter({
                $0.customer?.id == customerId
            })
            print(orders.orders[0].lineItems.count)
        })
    }
    func checkReachability() -> Bool {
        return reachability.networkStatus
    }
    func getUser()->Customer?{
        if let userData = UserDefaults.standard.object(forKey: "customer") as? Data {
            let decoder = JSONDecoder()
            if let customer = try? decoder.decode(Customer.self, from: userData) {
                return customer
            }
        }
        return nil
    }
}
