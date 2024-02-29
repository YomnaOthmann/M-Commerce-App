//
//  CheckoutViewModel.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 29/02/2024.
//

import Foundation

class CheckoutViewModel {
    
    var lineItemsTotalPrice:String?
    var lineItems:[LineItem]?
    var deliveryFee:String = "free"
    var discountValue:Int=0
    func getlineItemsTotalPrice()->String{
        
        return self.lineItemsTotalPrice ?? "0"
    }
    
    func getLineDeliveryFee()->String{
        
        if(deliveryFee == "free"){
            return "free"
        }
        
        return "10"
    }
    
    func checkCouponCode(couponCode:String,completion:(_ valid:Bool)->Void){
        
    }
    
    func getDiscountValue()->String{
        
        if discountValue == 0 {
            return "0"
        }
        
        return String(discountValue)
    }
    
    func getOrderTotalPrice()->String{
                
//        if(discountValue == 0){
//            return self.lineItemsTotalPrice
//        }else{
//            
//            let itemsTotalPrice = Float(lineItemsTotalPrice ?? "0.0")
//            let fainalOrderPrice = itemsTotalPrice + (itemsTotalPrice)
//            
//            return self.lineItemsTotalPrice ?? "0"
//
//        }
        return ""
    }
    
}
