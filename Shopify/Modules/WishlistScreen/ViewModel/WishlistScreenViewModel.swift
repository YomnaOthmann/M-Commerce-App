//
//  WishlistScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 05/03/2024.
//

import Foundation

class WishlistScreenViewModel{
    let network : NetworkManagerProtocol
    var wishlist : DraftOrder?{
        didSet{
            bindResult()
        }
    }
    var bindResult : ()->() = {}
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    func fetchWishlist(){
        let wishId = UserDefaults.standard.integer(forKey: "wishId")
        print(wishId)
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(wishId)" + APIHandler.APICompletions.json.rawValue
        print(url)
        network.fetch(url: url, type: PostDraftOrder.self) {[weak self] wishDraft in
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
}
