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
    func didLoadCustomer(customer:Customer)
}

protocol HomeScreenViewModelProtocol {
    func fetchAds()
    func fetchBrands()
    func fetchCustomer(mail:String, completionHandler:((Customer?)->())?)
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
    let defaults = UserDefaults.standard
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
    
    func savePriceRule(priceRules:PriceRules?,discountCode:DiscountCode?){
        guard let priceRules = priceRules else{
            return
        }
        
        do{
            
            for priceRule in priceRules.priceRules ?? [] {
                
                if priceRule.id == discountCode?.priceRuleID {
                    
                    print("priceRule in savePriceRule priceRuleKey value:\(priceRule.value ?? "no value")")
                    
                    let discountCodeData = try JSONEncoder().encode(discountCode)
                    defaults.set(discountCodeData, forKey: "discountCodeKey")
                    
                    let priceRuleData = try JSONEncoder().encode(priceRule)
                    defaults.set(priceRuleData, forKey: "priceRuleKey")
                    
                    break
                }
            }
            
        }
        
        catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    func fetchCustomer(mail:String, completionHandler:((Customer?)->())? = nil){
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        network.fetch(url: url, type: Customers.self, completionHandler: { [weak self] result in
            
            guard let customers = result else{
                return
            }
            let customer = customers.customers?.filter({
                $0.email == mail
            }).first
            print("from home model")
            guard let customer = customer else{
                completionHandler?(nil)
                return
            }
            completionHandler?(customer)
            print(customer.id)
            print(customer.tags)
            self?.defaults.set(customer.id,forKey: "customerId")
            
            self?.delegate?.didLoadCustomer(customer: customer)
            
        })
        
    }
    
    func getCustomerEmailFromDefaults()->String{
        return defaults.string(forKey: "customerMail") ?? ""
    }
    
    func checkReachability()->Bool{
        return reachability.networkStatus
    }
    
    
    
    func fetchWishlistAndCart(completionHandler:@escaping(DraftOrder?,DraftOrder?)->()){
        
        guard let customer = UserDefaults.standard.object(forKey: "customer") as? Data else{
            return
        }
        let decoder = JSONDecoder()
        guard let loadedCustomer = try? decoder.decode(Customer.self, from: customer) else{
            return
        }
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + APIHandler.APICompletions.json.rawValue
        network.fetch(url: url, type: DraftOrders.self) {[weak self] result in
            
            guard let draftOrders = result else{
                return
            }
            let drafts = draftOrders.draftOrders?.filter({
                $0.customer?.id == loadedCustomer.id
            })
            guard let drafts = drafts else{
                completionHandler(nil,nil)
                return
            }
            if drafts[0].tags == "wish"{
                let wish = drafts[0]
                let cart = drafts[1]
                completionHandler(wish,cart)
            }else{
                let cart = drafts[0]
                let wish = drafts[1]
                completionHandler(wish,cart)
            }
            
            
        }
        
    }
    
    
}
