//
//  CategoryScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import Foundation

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
        var firstFilter : [Product] = []
        if mainCategory == "all"{
            firstFilter = getAllItems(products: products)
            return firstFilter
        }
        else{
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
            print(products.count)
            return products
        }
        func getWomenItems(products:[Product])->[Product]{
            let products = products.filter({
                $0.tags.components(separatedBy: ", ").contains { item in
                    item.lowercased() == "women"
                }
                
            })
            print(products.count)
            return products
        }
        func getKidsItems(products:[Product])->[Product]{
            let products = products.filter({
                $0.tags.components(separatedBy: ", ").contains { item in
                    item.lowercased() == "kid"
                }
                
            })
            print(products.count)
            return products
        }
        func getAllItems(products:[Product])->[Product]{
            return products
        }
        
        
        
        
    }
