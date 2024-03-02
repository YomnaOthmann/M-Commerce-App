//
//  NewOrderSummaryViewModel.swift
//  Shopify
//
//  Created by Mac on 02/03/2024.
//

import Foundation

class NewOrderSummaryViewModel {
    
    let network : NetworkManagerProtocol?
    let reachability = NetworkReachability.networkReachability
    
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    
    func postOrder(order:Order){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + APIHandler.APICompletions.json.rawValue
        //TODO: - recieve real order from checkout
        
        let taxLine = [TaxLine(price: "20.0", title: "Shipping tax" )]
        let lineItems = [
            LineItem(name: "ADIDAS PINK SHOES FOR WOMEN", price: "200.0", productExists: true, quantity: 3, title: "ADIDAS PINK SHOES FOR WOMEN", totalDiscount: "40.0",vendor: "ADIDAS", taxLines: taxLine),
            LineItem(name: "ADIDAS PINK SHOES FOR WOMEN", price: "200.0", productExists: true, quantity: 3, title: "ADIDAS PINK SHOES FOR WOMEN", totalDiscount: "40.0",vendor: "ADIDAS", taxLines: taxLine)
        ]
        let order = Order(financialStatus: .pending, lineItems: lineItems)
        let newOrder = NewOrder(order: order)
        
        
        
        network?.post(url: url, parameters: newOrder, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                // TODO: show confirmation
                break
                
            default:
                //TODO: show warning
                break
            }
        })
    }
    
    
    func checkReachability() -> Bool {
        return reachability.networkStatus
    }
}
