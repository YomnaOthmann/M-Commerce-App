//
//  CheckoutViewModelsTests.swift
//  ShopifyTests
//
//  Created by Faisal TagEldeen on 02/03/2024.
//

import XCTest
@testable import Shopify

final class CheckoutViewModelsTests: XCTestCase {

    var checkoutViewModel:CheckoutViewModel = CheckoutViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCurrency(){
        
        let value = checkoutViewModel.getCurrency()
        XCTAssert(value == "EGP", "is not the egyptian Currency")
    }
    
    func testGetLineItemsTotalPrice(){
        
    
        checkoutViewModel.lineItemsTotalPrice = "498.0"
        let value = checkoutViewModel.getlineItemsTotalPrice()
        
        print(value)
        XCTAssert(value == "498.0 EGP", "method not working")
        
    }
    
    func testGetLineItemsTotalPriceWithoutCurrency(){
        
        checkoutViewModel.lineItemsTotalPrice = "498.0"
        let value = checkoutViewModel.getlineItemsTotalPriceWithoutCurrency()
        
        print(value)
        XCTAssert(value == "498.0", "method not working")
        
    }
    
    
}
