//
//  ProductDetailsViewModel.swift
//  Shopify
//
//  Created by Mac on 05/03/2024.
//

import Foundation
import UIKit


class ProductDetailsViewModel{
    
    //MARK: - Properties
    let apiNetworkManager = APIHandler()
    let custemerId = UserDefaults.standard.integer(forKey: K.customerIdKey)
    var ProductId:Int
    
    var availableQuatitySizeAndColor = 0
    var priceOfItemIneachVariant:String?
    var variaintID:Int? = 0
    static var indexOfColor:String? = ""
    static var indexOfSize:String? = ""
    
    var productItem:Product?{
        didSet{
            ProductDetailsViewModel.indexOfSize = productItem?.options.first?.values[0]
            ProductDetailsViewModel.indexOfColor = productItem?.options[1].values[0]
            variaintID = productItem?.variants.first?.id
            
            if let numberOfItemAvalabile = productItem?.variants.first?.inventoryQuantity{
                availableQuatitySizeAndColor = numberOfItemAvalabile
            }
        }
    }
   
  
    var favoriteProducts:[Product] = [] {
        didSet{
            for favoriteProduct in favoriteProducts {
                if favoriteProduct.id == productItem?.id{
                    setProductAsFavorites?()
                }
            }
        }
    }
    var numberOfItemsUpdates:Int = 0 {
        didSet{
            updateQuatitySelect?()
        }
    }
   
    
    
    //MARK: - Initilization Of Product Details
    init(for productID: Int) {
        self.ProductId = productID
    }
    
    
    
    
    
    
    
    //MARK: - Closures
    var reload:(()->Void)?
    var isLoadingAnimation:((Bool)->Void)?
    var errorOccurs:((String)->Void)?
    var alertNotification:((_ title:String,_ message:String)->Void)?
    var notifyAddedToCart:(()->Void)?
    var setProductAsFavorites:(()->Void)?
    var updateQuatitySelect:(()->Void)?
    
 
    //MARK: - Computed Property
    
    var productItemDetails:Product? {productItem}
    var nameOfProduct:String? {productItem?.title}
    var nameProductBrand:String? {productItem?.vendor}
    var descriptionOfProduct:String? {productItem?.description}
    var avalibleQuantity:Int? {
        if let numberOfItemAvalabile = productItem?.variants.first?.inventoryQuantity{
            
                return numberOfItemAvalabile
             
        }
        return 0
    }
    var priceOfSingleItem:Double? {
        if let priceOfSingleProduct =  Double(productItem?.variants.first?.price ?? "0.0"){
            if priceOfItemIneachVariant != nil{
                return Double ( priceOfItemIneachVariant  ?? "0.0")
            }else{
                return priceOfSingleProduct
            }
        }
        return nil
        
    }
    var priceOfsingleProduct: String {
        if let priceitem = productItem?.variants.first?.price {
            return "\(priceitem)"
        }
        return ""
    }
    var numeberOfAvalibleQuantity:String?{
        if let numberOfItemAvalabile = productItem?.variants.first?.inventoryQuantity{
            return "\(numberOfItemAvalabile) item"
            
        }
        return nil
        
    }
    var numberOfQuantityUpdates:Int? {numberOfItemsUpdates}
   
    
 
    
    //MARK: - Network Call For Price of Product
    
//    func priceOfSingleProduct() {
//        
//        apiNetworkManager.fetch(url: "", type: ProductContainer.self , completionHandler: { result in
//            
//            self.productItem = result?.product
//                self.checkCustomerFavoriteProduct(for: self.custemerId)
//                self.isLoadingAnimation?(false)
//                self.reload?()
//            
//        })
//    }

    
    
    //MARK: - Adding New Item
    func addNewItemToCart(availableQuantity:String?){
        
        if let fullText = availableQuantity?.components(separatedBy: " "){
            let number = fullText[0]
            
            if let actualNumber = Int (number){
                print("DArta \(numberOfItemsUpdates) \(actualNumber/2) ")
                if ((actualNumber == 1) && (numberOfItemsUpdates <= 1))
                {
                    numberOfItemsUpdates += 1

                }
                else if ((numberOfItemsUpdates <= (actualNumber/2)) && (actualNumber != 0)){
                    numberOfItemsUpdates += 1
                }else{
                    if actualNumber ==  0 {
                        alertNotification?("Out of Stock","This Item You choosen is out of Stock.")
                    }else{
                        alertNotification?("Maxmium Limit","You Reached Maximum Limit For You.")
                    }
                  
                }
            }
        }
    }
    
    //MARK: - Remove One Item
    func removeOneItemFromCart(){
        
        
        if numberOfItemsUpdates > 0{
            numberOfItemsUpdates -= 1
            
        }else{
            alertNotification?("Add Item","Please Add Item To Allow Decrease Quantity!")
        }
        
        
    }
    
    //MARK: - Set Or Remove Error
    func setOrRemoveFavoriteProduct(sender:UIButton){
        if  sender.currentImage == UIImage(systemName:  K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)){
            sender.setImage(UIImage(systemName: K.favoriteIconSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)

            
        }else{
            
            sender.setImage(UIImage(systemName: K.favoriteIconNotSave,withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)

        }
        
        
    }
    
    
    //MARK: - to Check Favorites Product Of Customer
    func checkCustomerFavoriteProduct(for custmerId:Int){
            isLoadingAnimation?(true)

        }
    
    
    
    //MARK: - Decrease And Increase Quantity
    func updateAvalibleQuantity()->Double{
        print("priceOfSingleItem \(priceOfSingleItem)")
        print("numberOfItemsUpdates \(numberOfItemsUpdates)")
        print("Double price\(Double (numberOfItemsUpdates) * (priceOfSingleItem ?? 0.0))")
        return  Double (numberOfItemsUpdates) * (priceOfSingleItem ?? 0.0)
    }
    
    func addProductToCart(){
        guard let variaintID = variaintID else {
            self.errorOccurs?("Please select size and color for the product to add to the cart")
            return
        }
        
        guard let quantity = numberOfQuantityUpdates else {
            self.errorOccurs?("Please choose quantity for the product!")
            return
        }
        

        
        self.isLoadingAnimation?(true)
        

    }
    
    
}
