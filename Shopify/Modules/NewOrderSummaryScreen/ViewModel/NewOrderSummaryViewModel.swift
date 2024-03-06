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
    
    func postOrder(order:Order?, completionHandler: @escaping (Int?)->()){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + APIHandler.APICompletions.json.rawValue
        //TODO: - recieve real order from checkout
        
//        let taxLine = [TaxLine(price: "20.0", title: "Shipping tax" )]
//        
//        let properties = [OrderProperty(name: "https://www.vhv.rs/dpng/d/490-4909527_sneakers-download-png-image-pink-sneakers-png-transparent.png")]
//        
//        let lineItems = [
//            LineItem(name: "ADIDAS PINK SHOES FOR WOMEN", price: "200.0", productExists: true, quantity: 3, title: "ADIDAS PINK SHOES FOR WOMEN", totalDiscount: "40.0",vendor: "ADIDAS", taxLines: taxLine,propertis: properties),
//            LineItem(name: "ADIDAS PINK SHOES FOR WOMEN", price: "200.0", productExists: true, quantity: 3, title: "ADIDAS PINK SHOES FOR WOMEN", totalDiscount: "40.0",vendor: "ADIDAS", taxLines: taxLine,propertis: properties)
//        ]
        
//        guard let customer = UserDefaults.standard.object(forKey: "customer") as? Data else{
//                return
//        }
//        let decoder = JSONDecoder()
//        guard let loadedCustomer = try? decoder.decode(Customer.self, from: customer) else{
//                return
//        }
//        print("order"+"\(loadedCustomer.id)")
//        let order = Order(id: 0, confirmed: nil, createdAt: nil, currency: nil, currentTotalDiscounts: nil, currentTotalPrice: nil, financialStatus: .pending, name: nil, number: nil, orderNumber: nil, processedAt: nil, subtotalPrice: nil, token: nil, totalDiscounts: nil, totalLineItemsPrice: nil, totalPrice: nil, customer: loadedCustomer, lineItems: lineItems, shippingAddress: Address(id: 0, customerID: 0, address1: "", address2: "", city: "", province: "", country: "", zip: "", phone: "", name: "", provinceCode: "", countryCode: "", countryName: "", addressDefault: false), taxLines: taxLine)
        guard let order = order else{
            print("invalid order")
            return
        }
        let newOrder = NewOrder(order: order)
        
        network?.post(url: url, parameters: newOrder, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                completionHandler(statusCode)
                break
                
            default:
                completionHandler(nil)
                break
            }
        })
    }
    
    
    
    func checkReachability() -> Bool {
        return reachability.networkStatus
    }
}
