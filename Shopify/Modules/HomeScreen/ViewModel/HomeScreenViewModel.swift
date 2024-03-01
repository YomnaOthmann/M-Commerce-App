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
    var discountCodes : DiscountCodes?{
        didSet{
            bindResult()
        }
    }
    var bindResult : (()->()) = {}
    weak var delegate : HomeScreenViewModelDelegate?
    var network : NetworkManagerProtocol
    let reachability = NetworkReachability.networkReachability
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
    func fetchDiscountCodes(priceRuleId:Int){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.priceRule.rawValue + "/\(self.ads?.priceRules?[0].id ?? 0)" + APIHandler.APIEndPoints.discountCode.rawValue + APIHandler.APICompletions.json.rawValue
        print(url)
        network.fetch(url: url, type: DiscountCodes.self) {[weak self] result in
            guard let discountCodes = result else{
                return
            }
            self?.discountCodes = discountCodes
        }
    }
    
    func checkReachability()->Bool{
        return reachability.networkStatus
    }
}
