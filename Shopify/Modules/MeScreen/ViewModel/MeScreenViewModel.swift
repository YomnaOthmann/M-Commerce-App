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
    var wishlist : DraftOrder?{
        didSet{
            bindResult()
        }
    }
    var bindResult : ()->() = {}
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
    
    func fetchWishlist(){
        let wishId = UserDefaults.standard.integer(forKey: "wishId")
        print(wishId)
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(wishId)" + APIHandler.APICompletions.json.rawValue
        print(url)
        network?.fetch(url: url, type: PostDraftOrder.self) {[weak self] wishDraft in
            guard var wish = wishDraft?.draftOrder else{
                return
            }
            print(wish.lineItems?.count)
            var tempWish : [LineItem] = []
            for index in 0..<(wish.lineItems?.count ?? 0 ) {
                if wish.lineItems?[index].title != "dummy"{
                    guard let item = wish.lineItems?[index] else{
                        return
                    }
                    tempWish.append(item)
                }
            }
            print(wish.lineItems?.count)
            wish.lineItems = tempWish
            print(wish.lineItems?.count)
            self?.wishlist = wish
        }
    }
    
    func editWishlist(draft:DraftOrder?, lineitem:LineItem?){
        var flag = false
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(draft?.id ?? 0)" + APIHandler.APICompletions.json.rawValue
        var draft = draft
        let dummyItem = LineItem(name: "dummy", price: "0.0", productExists: false, productID: 0, quantity: 1, title: "dummy", totalDiscount: "0.0", taxLines: [], propertis: [])
        guard let lineItems = draft?.lineItems else{
            return
        }
        for (index,item) in lineItems.enumerated(){
            if flag == true{
                break
            }
            if lineitem?.title == item.title{
                flag = true
                draft?.lineItems?.remove(at: index)
                if draft?.lineItems?.count == 0{
                    draft?.lineItems?.append(dummyItem)
                }
            }else{
                flag = false
            }
        }

        let newDraft = PostDraftOrder(draftOrder: draft)
        network?.put(url: url, parameters: newDraft, completionHandler: {[weak self] code in
            switch code{
            case 200:
                print("wishlist edited")
                self?.fetchWishlist()
            default:
                print("failed to edit wishlist")
            }
        })
    }
    
}
