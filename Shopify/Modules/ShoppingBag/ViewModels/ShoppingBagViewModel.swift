//
//  ShoppingBagViewModel.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 28/02/2024.
//

import Foundation

class ShoppingBagViewModel {
    
    
    var dataObserver:()->Void = {}
    
    private var lineItems:[LineItem] = []{
        
        didSet{
            dataObserver()
        }
    }

    func fetchData(){
        lineItems = self.getDummyData()
    }
    
    func getLineItmesCount()->Int{
        
        return lineItems.count
    }
    
    func getLineItems()->[LineItem]{
        return self.lineItems
    }
    
    func getLineItemTitle(atIndex index:Int)->String{
        
        return lineItems[index].title
    }
    
    func getLineItemSubTitle(atIndex index:Int)->String{
        
        return lineItems[index].name
    }
    
    func getLineItemTotalPrice(atIndex index:Int)->String{
        
        let totalPrice = (Float(lineItems[index].price) ?? 0) * Float(lineItems[index].quantity)
        
        return String(totalPrice)
    }
    
    func getLineItemQuantity(atIndex index:Int)->String{
        
        return String(lineItems[index].quantity)
    }
    
    func getLineItemInStockQuantity(atIndex index:Int)->String{
        
        return "\(lineItems[index].currentQuantity ?? 0)"
    }
    
    func getLineItemDeliverBy(atIndex index:Int)->String{
        
        return Date().deliverByFormToday(addedDays: 5, dateFormat: "dd MMM YYYY")
    }
    
    func increaseLineItemQuantity(atIndex index:Int){
        
        var quantity = lineItems[index].quantity
        guard let currentQuantity = lineItems[index].currentQuantity else { return }
        
        guard quantity < currentQuantity else{return}
        
        quantity += 1
        lineItems[index].quantity = quantity
        
        dataObserver()
    }
    
    func decreaseLineItemQuantity(atIndex index:Int){
        
        var quantity = lineItems[index].quantity
        
        guard quantity > 0 else{return}
        
        quantity -= 1
        lineItems[index].quantity = quantity

        dataObserver()
    }
    
    func getLineItemsTotalPrice()->String{
        
        var totalPrice:Float = 0.0
        
        for item in lineItems{
            
            let price = Float(item.price) ?? 0
            let quantity = Float(item.quantity)
            
            totalPrice = totalPrice + (price  * quantity)
        }
        
        return String(totalPrice)
    }
    
}

extension ShoppingBagViewModel {
    
    private func getDummyData()->[LineItem]{
        let taxLines = [TaxLine(price: "23.5", title: "Tax Fees")]
        let properties = [OrderProperty(name: "https://image.pngaaa.com/595/489595-middle.png")]
        let appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: 8, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 1, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: taxLines,propertis: properties)
        
        return [appleItem,appleItem,appleItem]
    }
}

extension Date{
   
    func deliverByFormToday(addedDays days:Int,dateFormat format:String)->String{
        
        let modifiedDate = Calendar.current.date(byAdding: .day, value: days, to: self)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: modifiedDate)
    }
    
}

    
