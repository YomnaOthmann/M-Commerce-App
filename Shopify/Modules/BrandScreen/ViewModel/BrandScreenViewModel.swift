//
//  BrandScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import Foundation

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

    func editProduct(product:Product){
        
    }
    func checkReachability()->Bool{
        return reachability.networkStatus
    }

}
