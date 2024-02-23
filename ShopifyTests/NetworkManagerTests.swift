//
//  NetworkManagerTests.swift
//  ShopifyTests
//
//  Created by Mac on 22/02/2024.
//

import XCTest
@testable import Shopify
final class NetworkManagerTests: XCTestCase {

    var network : NetworkManagerProtocol?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchingData(){
        network = NetworkManager()
        let expectation = expectation(description: "test fetching products")
        
        let url = "https://e68611fa195924ce2d11aa1909193f1b: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@q2-23-24-ios-sv-team1.myshopify.com/admin/api/2024-01/products.json"

        network?.fetch(url: url, type: Products.self, completionHandler: { result in
            guard let products = result else{
                expectation.fulfill()
                XCTFail("result are nil")
                return
            }
            expectation.fulfill()
            XCTAssert(products.products.count > 0, "products coutn are 0")
        })
        waitForExpectations(timeout: 5)
    }
    
    func testFetchingDataShouldFail(){
        network = NetworkManager()
        let expectation = expectation(description: "test fetching products to fail")
        
        let url = "https://e68611fa195924ce2d11aa1909193f1b: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@q2-23-24-ios-sv-team1.myshopify.com/admin/api/2024-01/roducts.json"

        network?.fetch(url: url, type: Products.self, completionHandler: { result in
            guard let products = result else{
                expectation.fulfill()
                XCTAssertNil(result)
                return
            }
            expectation.fulfill()
            XCTAssert(products.products.count > 0, "products coutn are 0")
        })
        waitForExpectations(timeout: 5)
    }



}
