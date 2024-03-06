//
//  CategoryScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import Foundation
import UIKit

protocol CategoryScreenViewModelProtocol{
    func checkReachability()->Bool
    func fetchProducts()
}
protocol CategoryScreenViewModelDelegate : AnyObject{
    func setFilteredProducts()
}

class CategoryScreenViewModel:CategoryScreenViewModelProtocol{
    
    let network : NetworkManagerProtocol?
    let reachability = NetworkReachability.networkReachability
    var bindResult : ()->() = {}
    weak var delegate : CategoryScreenViewModelDelegate?
    var allProducts : Products?{
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
    var bindEditedProduct : ()->() = {}
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    
    func checkReachability()->Bool {
        return reachability.networkStatus
    }
    
    func fetchProducts() {
        
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.products.rawValue + APIHandler.APICompletions.json.rawValue
        
        network?.fetch(url: url, type: Products.self, completionHandler: {[weak self] result in
            guard let products = result else{
                return
            }
            self?.allProducts = products
            
        })
    }
    func filterProducts(products:[Product], mainCategory : String, subCategory:Product.ProductType)->[Product]{
        print("\(mainCategory) \(subCategory)")
        var firstFilter : [Product] = []
        if mainCategory == "all"{
            firstFilter = getAllItems(products: products)
        }
        else if mainCategory == "women"{
            firstFilter = getWomenItems(products: products)
            
        }else if mainCategory == "men"{
            firstFilter = getMenItems(products: products)
        }
        else {
            firstFilter = getKidsItems(products: products)
        }
        if subCategory == .all{
            return firstFilter
        }else{
            let finalFilter = firstFilter.filter({
                $0.productType == subCategory
            })
            return finalFilter
        }
    }
    func getMenItems(products:[Product])->[Product]{
        let products = products.filter({
            $0.tags.components(separatedBy: ", ").contains { item in
                item.lowercased() == "men"
            }
        })
        return products
    }
    func getWomenItems(products:[Product])->[Product]{
        let products = products.filter({
            $0.tags.components(separatedBy: ", ").contains { item in
                item.lowercased() == "women"
            }
        })
        return products
    }
    func getKidsItems(products:[Product])->[Product]{
        let products = products.filter({
            $0.tags.components(separatedBy: ", ").contains { item in
                item.lowercased() == "kid"
            }
        })
        return products
    }
    func getAllItems(products:[Product])->[Product]{
        return products
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
    
    func editProduct(product:Product?, isFav:Bool?,completionHandler:@escaping(Product?)->()){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.products.rawValue + "/\(product?.id ?? 0)" + APIHandler.APICompletions.json.rawValue
        var product = product
        product?.templateSuffix = isFav ?? true ? "fav" : nil
        let newProduct = NewProduct(product: product)
        network?.put(url: url, parameters: newProduct, completionHandler: {[weak self] code in
            switch code{
            case 200:
                print("product edited")
                completionHandler(product)
                self?.fetchProducts()
            default:
                completionHandler(nil)
                print("failed to edit product")
            }
        })
    }
    func editWishlist(draft:DraftOrder?, product:Product?){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + "/\(draft?.id ?? 0)" + APIHandler.APICompletions.json.rawValue
        var draft = draft
        if product?.templateSuffix == nil{
            print("line items count  = \(draft?.lineItems?.count)")
            for index in 0..<(draft?.lineItems?.count ?? 0){
                if draft?.lineItems?[index].productID == product?.id{
                    draft?.lineItems?.remove(at: index)
                }
            }
            print("line items count  = \(draft?.lineItems?.count)")
        }else if product?.templateSuffix == "fav"{
            
            let newItem = LineItem(name: product?.title ?? "", price: product?.variants[0].price ?? "", productExists: true, productID: product?.id, quantity: 1, title: product?.title ?? "", totalDiscount: "0.0", taxLines: [], propertis: [OrderProperty(name: product?.images[0].src)])
            print("line items count  = \(draft?.lineItems?.count)")
            print("new item \(newItem)")
            draft?.lineItems?.append(newItem)
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
    func getButtonColor(isFav:Bool)->UIColor{
        return isFav ? UIColor.red : UIColor.black
    }
    func getButtonImage(isFav:Bool)->UIImage?{
        return isFav ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
}
