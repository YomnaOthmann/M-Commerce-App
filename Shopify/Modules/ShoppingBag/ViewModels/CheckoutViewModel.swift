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
    var order:Order?
    
    func getOrderBuilder()-> OrderBuilder {
        
        let orderBuilder = OrderBuilder()
        
        orderBuilder.setLineItems(lineItems: getLineItems())
        
        orderBuilder.setSubTotalPrice(subTotalPrice: getlineItemsTotalPriceWithoutCurrency())
        
        orderBuilder.setCurrentTotalDiscounts(
            currentTotalDiscounts:getDiscountWithoutCurrency())
        
        orderBuilder.setCurrency(currency: getCurrency())
        
        orderBuilder.setCurrentTotalPrice(currentTotalPrice: getOrderTotalPriceWithoutCurrency())
        
        return orderBuilder
    }
    
    
    func getLineItems()->[LineItem]{
        return self.lineItems ?? []
    }
    
    func getlineItemsTotalPrice()-> String {
        
        return (self.lineItemsTotalPrice ?? "0") + " " + getCurrency()
    }
    
    func getlineItemsTotalPriceWithoutCurrency()-> String {
        
        return  self.lineItemsTotalPrice ?? "0" 
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
            
            let lineItemsPriceInFloat:Float = Float(self.lineItemsTotalPrice ?? "0") ?? 0
            let discountValueInPercentage:Float = Float(priceRule.value ?? "0") ?? 0
            let discountValue:Float = lineItemsPriceInFloat * (discountValueInPercentage/100)
            
            return String(format : "%.2f ", discountValue) + getCurrency()
        }
    }
    
    func getDiscountWithoutCurrency()-> String {
        
        guard let priceRule = getSavedPriceRule() else {return "0"}
        
        if priceRule.valueType == "fixed_amount"{
            
            return  (priceRule.value ?? "0")
        }else{
            
            let lineItemsPriceInFloat = Float(self.lineItemsTotalPrice ?? "0")
            let discountValueInPercentage = Float(priceRule.value ?? "0")
            let discountValue = lineItemsPriceInFloat! * (discountValueInPercentage!/100)
            
            return String(format : "%.2f ", discountValue)
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
            
            print(lineItemsPriceInFloat ?? "0")
            
            let discountValue = Float(priceRule.value ?? "0")
            
            let orderTotalPriceInDouble = (lineItemsPriceInFloat ?? 0.00) + ((lineItemsPriceInFloat ?? 0) * (discountValue!/100.0))
            
            orderTotalPrice =
            String(format : "%.2f ", orderTotalPriceInDouble)
        }
        
        return orderTotalPrice
    }
    
    func getOrderTotalPrice()->String{
        return self.getOrderTotalPriceWithoutCurrency() + " " + self.getCurrency()
    }
}

class OrderBuilder{
    
    private var lineItems:[LineItem]?
    private var subTotalPrice:String?
    private var currency:String?
    private var currentTotalDiscounts:String?
    private var currentTotalPrice:String?
    private var shippingAddress:Address?
    private var customerID:Int?
    
    func setLineItems(lineItems:[LineItem]){
        self.lineItems = lineItems
    }
    
    func setCustomerID(id:Int){
        self.customerID = id
    }
    
    func setSubTotalPrice(subTotalPrice:String){
        self.subTotalPrice = subTotalPrice
    }
    func setCurrency(currency:String){
        self.currency = currency
    }
    func setCurrentTotalDiscounts(currentTotalDiscounts:String){
        self.currentTotalDiscounts = currentTotalDiscounts
    }
    
    func setCurrentTotalPrice(currentTotalPrice:String){
        self.currentTotalPrice = currentTotalPrice
    }
    
    func setShippingAddress(shippingAddress:Address){
        self.shippingAddress = shippingAddress
    }
    
    func build()->Order{
        
        var order = Order(financialStatus: nil, lineItems: lineItems ?? [])
        order.subtotalPrice = subTotalPrice
        order.currency = currency
        order.currentTotalDiscounts = currentTotalDiscounts
        order.currentTotalPrice = currentTotalPrice
        order.shippingAddress = shippingAddress
      //  order.customer = Customer(email: nil, firstName: nil, lastName: nil)
      //  order.customer?.id = customerID

        if let customer = UserDefaults.standard.object(forKey: "customer") as? Data{
            let decoder = JSONDecoder()
            if let loadedCustomer = try? decoder.decode(Customer.self, from: customer){
                order.customer = loadedCustomer
            }else{
                      order.customer = Customer(email: "", createdAt: "", updatedAt: "", firstName: "", lastName: "", ordersCount: 0, state: "", totalSpent: "", lastOrderID: 0, verifiedEmail: false, tags: "", lastOrderName: "", currency: "", phone: "", addresses: [], emailMarketingConsent: nil, smsMarketingConsent: nil, adminGraphqlAPIID: "", defaultAddress: nil)
                order.customer?.id = customerID

                  }
        }else{
                       order.customer = Customer(email: "", createdAt: "", updatedAt: "", firstName: "", lastName: "", ordersCount: 0, state: "", totalSpent: "", lastOrderID: 0, verifiedEmail: false, tags: "", lastOrderName: "", currency: "", phone: "", addresses: [], emailMarketingConsent: nil, smsMarketingConsent: nil, adminGraphqlAPIID: "", defaultAddress: nil)
                      order.customer?.id = customerID

        }
        //order.customer?.id = customerID
        
        return order
    }
    
}
