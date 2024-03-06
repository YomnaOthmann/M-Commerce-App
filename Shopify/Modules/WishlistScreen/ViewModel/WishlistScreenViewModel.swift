//
//  WishlistScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 05/03/2024.
//

import Foundation
import UIKit

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
        network.put(url: url, parameters: newDraft, completionHandler: {[weak self] code in
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
