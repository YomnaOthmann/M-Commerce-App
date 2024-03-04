//
//  CheckoutViewModel.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 29/02/2024.
//

import Foundation

class CheckoutViewModel {
    
    var lineItemsTotalPrice:String? = "0"
    var lineItems:[LineItem]?
    var discountValue:Int=0
    
    func getlineItemsTotalPrice()-> String {
        
        return self.lineItemsTotalPrice ?? "0"
    }
            
//    func checkCouponCode(couponCode:String,completion:(_ valid:Bool)->Void){
//        
 //  }
    
    func getSavedPriceRule()-> PriceRule? {
        
        
        if let savedPriceRule = UserDefaults.standard.object(forKey: "priceRuleKey") as? Data {
                let decoder = JSONDecoder()
                if let loadedPriceRule = try? decoder.decode(PriceRule.self, from: savedPriceRule) {
                
                    print("savedPriceRule exist")
                    return loadedPriceRule
                }
            }
        
            return nil
    }
    
    func getCurrency()-> String {
        return "EGP"
    }
    
    func getDiscount()-> String {
        
        guard let priceRule = getSavedPriceRule() else {return "0"}
        
        if priceRule.valueType == "fixed_amount"{
            
            return  (priceRule.value ?? "0") + getCurrency()
        }else{
            
            return (priceRule.value ?? "0" ) + " %"
        }
    }
    
    func getOrderTotalPriceWithoutCurrency()->String{
         
        var orderTotalPrice = self.lineItemsTotalPrice ?? "0"
        let lineItemsPriceInFloat = Float(self.lineItemsTotalPrice ?? "0")
        
        print("self.lineItemsTotalPrice : \(self.lineItemsTotalPrice)")
        
        guard let priceRule = getSavedPriceRule() else {return orderTotalPrice}
        
        if priceRule.valueType == "fixed_amount"{
            
            let discountValue = Float(priceRule.value ??  "0")
            print("priceRule.valueType == fixed_amount")
            print(priceRule.value)
            
            orderTotalPrice = String(format : "%.2f ",lineItemsPriceInFloat! + discountValue!)
                        
        }else{
            print("priceRule.valueType == prcentege")
            print(priceRule.value)
            
            print(lineItemsPriceInFloat!)
            
            let discountValue = Float(priceRule.value ?? "0")
            
            orderTotalPrice = String(format : "%.2f ", -1 * ((lineItemsPriceInFloat ?? 0) * (discountValue!/100.0)))
        }
        
        return orderTotalPrice
    }
    
    func getOrderTotalPrice()->String{
        return self.getOrderTotalPriceWithoutCurrency() + " " + self.getCurrency()
    }
}
