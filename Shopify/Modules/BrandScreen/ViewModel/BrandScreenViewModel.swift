//
//  BrandScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import Foundation
import UIKit
protocol BrandScreenViewModelProtocol{
    func fetchProducts(brandName:String?)
}
class BrandScreenViewModel : BrandScreenViewModelProtocol{
    
    let reachability = NetworkReachability.networkReachability
    let network:NetworkManagerProtocol?
    var bindResult : ()->() = {}
    var brandProducts:[Product]?{
        didSet{
            bindResult()
        }
    }
    var bindWishlist : ()->() = {}
    var wishlist : DraftOrder?{
        didSet{
            bindWishlist()
        }
    }
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    
    func fetchProducts(brandName: String?) {
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.products.rawValue + APIHandler.APICompletions.json.rawValue
        
        network?.fetch(url: url, type: Products.self, completionHandler: { [weak self] result in
            guard let products = result else {
                return
            }
            
            var filteredProducts: [Product]
            
            if let brandName = brandName, !brandName.isEmpty {
                filteredProducts = products.products.filter {
                    $0.vendor == brandName
                }
            } else {
                filteredProducts = products.products
            }
            
            self?.brandProducts = filteredProducts
        })
    }

    func checkReachability()->Bool{
        return reachability.networkStatus
    }

    func editWishlist(draft:DraftOrder?, product:Product?){
        var flag = false
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(draft?.id ?? 0)" + APIHandler.APICompletions.json.rawValue
        var draft = draft
        guard let lineItems = draft?.lineItems else{
            return
        }
        for (index,item) in lineItems.enumerated(){
            if flag == true{
                break
            }
            if product?.title == item.title{
                flag = true
                draft?.lineItems?.remove(at: index)
            }else{
                flag = false
            }
        }
        if flag == false{
            let taxLine = [TaxLine(price: "0.0", title: "")]
            let lineItem = LineItem(name: product?.title ?? "", price: product?.variants[0].price ?? "", productExists: true, productID: product?.id, quantity: 1, title: product?.title ?? "", totalDiscount: "0.0", taxLines: taxLine, propertis: [OrderProperty(name: product?.images[0].src, value: "")])
                    draft?.lineItems?.append(lineItem)

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
    func fetchWishlist(){
        let wishId = UserDefaults.standard.integer(forKey: "wishId")
        print(wishId)
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(wishId)" + APIHandler.APICompletions.json.rawValue
        print(url)
        network?.fetch(url: url, type: PostDraftOrder.self) {[weak self] wishDraft in
            guard var wish = wishDraft?.draftOrder else{
                return
            }
            self?.wishlist = wish
        }
    }
    
    func getIsFav(product:Product?)->Bool{
        return product?.templateSuffix == nil ? false : true
    }
    func getButtonColor(isFav:Bool?)->UIColor{
        return isFav ?? false ? UIColor.red : UIColor.black
    }
    func getButtonImage(isFav:Bool?)->UIImage?{
        return isFav ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
}
