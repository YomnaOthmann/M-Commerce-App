//
//  MeScreenViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 02/03/2024.
//

import XCTest
@testable import Shopify
final class MeScreenViewModelTests: XCTestCase {
    
    let meViewModel = MeScreenViewModel(network: NetworkManager())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testFetchOrders(){
        let expectation = expectation(description: "test fetching orders")
        meViewModel.fetchOrders()
        meViewModel.bindOrders = {
            guard let orders = self.meViewModel.orders else{
                return
            }
            expectation.fulfill()
            XCTAssert(orders.count > 0, "orders count = 0")
        }
        waitForExpectations(timeout: 5)
        
    }
    
    func testCheckReachability(){
        XCTAssertTrue( meViewModel.checkReachability())
    }
    
    
}
