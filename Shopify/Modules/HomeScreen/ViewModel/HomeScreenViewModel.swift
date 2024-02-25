//
//  HomeScreenViewModel.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import Foundation

protocol HomeScreenViewModelDelegate : AnyObject{
    func didLoadAds(ads:PriceRules)
    func didLoadBrands(brands:SmartCollections)
}

protocol HomeScreenViewModelProtocol {
    func fetchAds()
    func fetchBrands()
}

class HomeScreenViewModel : HomeScreenViewModelProtocol{
    
    var ads : PriceRules? {
        didSet{
            bindResult()
        }
    }
    var brands : SmartCollections?{
        didSet{
            bindResult()
        }
    }
    var bindResult : (()->()) = {}
    weak var delegate : HomeScreenViewModelDelegate?
    var network : NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func fetchAds() {
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.priceRule.rawValue + APIHandler.APICompletions.json.rawValue
        
        network.fetch(url: url, type: PriceRules.self) {[weak self] result in
            guard let ads = result else{
                return
            }
            self?.ads = ads
            self?.delegate?.didLoadAds(ads: ads)
        }
    }
    
    func fetchBrands() {
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.smartCollection.rawValue + APIHandler.APICompletions.json.rawValue
        
        network.fetch(url: url, type: SmartCollections.self) {[weak self] result in
            guard let brands = result else{
                return
            }
            self?.brands = brands
            self?.delegate?.didLoadBrands(brands: brands)
        }
    }
}
