//
//  ShoppingBagViewModelTests.swift
//  ShopifyTests
//
//  Created by Faisal TagEldeen on 02/03/2024.
//

import XCTest
@testable import Shopify

final class ShoppingBagViewModelTests: XCTestCase {
    
    let shoppingBagVM:ShoppingBagViewModel = ShoppingBagViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCurrency(){
        
        let value =  shoppingBagVM.getCurrency()
        XCTAssert(value == "EGP", "is not the egyptian Currency")
    }
    
    func testFetchShoppinfBagData(){
        
        let expectation = expectation(description: "test fetching shoppingBag data")
        
        shoppingBagVM.dataObserver = {
            
            XCTAssert(self.shoppingBagVM.getLineItems().isEmpty == false, "shoppingBagVM data not fetched ")
            expectation.fulfill()
        }
        
        shoppingBagVM.fetchData()
        waitForExpectations(timeout: 10)
    }
    
    func testIncreaseQuantity(){
        
        let orderProperities = [OrderProperty(name:"in_stock" ,value: "8"),OrderProperty(name:"in_stock" ,value: "8")]
        var appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: nil, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 1, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: [])
        appleItem.properties = orderProperities
        
        let appleItems = [appleItem,appleItem]
    
        shoppingBagVM.lineItems = appleItems
        shoppingBagVM.increaseLineItemQuantity(atIndex: 0)
        
        let value = shoppingBagVM.getLineItemQuantity(atIndex: 0)
        
        XCTAssert(value == "2", "method increaseLineItemQuantity not working")
        
    }
    
    func testDecreaseQuantity(){
        
        let orderProperities = [OrderProperty(name:"in_stock" ,value: "8"),OrderProperty(name:"in_stock" ,value: "8")]
        var appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: nil, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 3, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: [])
        appleItem.properties = orderProperities
        
        let appleItems = [appleItem,appleItem]
    
        shoppingBagVM.lineItems = appleItems
        shoppingBagVM.decreaseLineItemQuantity(atIndex: 0)
        
        let value = shoppingBagVM.getLineItemQuantity(atIndex: 0)
        
        XCTAssert(value == "2", "method decreaseLineItemQuantity not working")
    }
    
    func testGetLineItemsTotalPrice(){
        
        let orderProperities = [OrderProperty(name:"in_stock" ,value: "8"),OrderProperty(name:"in_stock" ,value: "8")]
        var appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: nil, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 1, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: [])
        appleItem.properties = orderProperities
        
        let appleItems = [appleItem,appleItem]
    
        shoppingBagVM.lineItems = appleItems
        let value = shoppingBagVM.getLineItemsTotalPrice()
        
        XCTAssert(value == "498.0 EGP", "method not working")

    }
    
    func testGetLineItemInStockQuantity(){
        
        let orderProperities = [OrderProperty(name:"in_stock" ,value: "8"),OrderProperty(name:"in_stock" ,value: "8")]
        var appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: nil, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 1, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: [])
        appleItem.properties = orderProperities
        
        let appleItems = [appleItem,appleItem]
    
        shoppingBagVM.lineItems = appleItems
        let value = shoppingBagVM.getLineItemInStockQuantity(atIndex: 0)
        
        XCTAssert(value == "8", "method getLineItemInStockQuantity not working")

    }

    func testDeleteLineItem(){
        
        let orderProperities = [OrderProperty(name:"in_stock" ,value: "8"),OrderProperty(name:"in_stock" ,value: "8")]
        var appleItem = LineItem(id: 123, adminGraphqlAPIID: "no", currentQuantity: nil, giftCard:false, name: "Apple AirPods Pro 2nd generation", price: "249.0", productExists: true, productID: 12344, quantity: 1, sku: "fffg", title: "AirPods Pro", totalDiscount: "0", variantID: 1223, variantTitle: "title", vendor: "vendor",taxLines: [])
        appleItem.properties = orderProperities
        
        let appleItems = [appleItem,appleItem]
    
        shoppingBagVM.lineItems = appleItems
        shoppingBagVM.deleteLineItem(atIndex: 1)
        
        XCTAssert(shoppingBagVM.getLineItmesCount() == 1, "method deleteLineItem not working")
    }
    

}
