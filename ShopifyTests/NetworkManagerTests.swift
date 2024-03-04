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
        
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.products.rawValue + APIHandler.APICompletions.json.rawValue

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
    
    func testFetchingDataDecodingFail(){
        network = NetworkManager()
        let expectation = expectation(description: "test fetching products to fail")
        
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.products.rawValue + APIHandler.APICompletions.json.rawValue

        network?.fetch(url: url, type: SmartCollections.self, completionHandler: { result in
                expectation.fulfill()
                XCTAssertNil(result)
        })
        waitForExpectations(timeout: 5)
    }
    
    func testPostingData(){  
        let expectation = expectation(description: "test creating customer")
        
        network = NetworkManager()
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.orders.rawValue + APIHandler.APICompletions.json.rawValue
        
        let taxLines = [TaxLine(price: "23.7", title: "tax fees")]
       
        let properties = [OrderProperty(name:"https://cdn.shopify.com/s/files/1/0687/9772/6962/products/8a029d2035bfb80e473361dfc08449be.jpg?v=1709295198")]
       
        let lineItems = [LineItem(name: "ADIDAS | CLASSIC BACKPACK", price: "800.0", productExists: true, quantity: 2, title: "ADIDAS | CLASSIC BACKPACK", totalDiscount: "80.0", taxLines: taxLines,propertis: properties)]
        
        let newOrder = NewOrder(order: Order(financialStatus: .pending, lineItems: lineItems))
        network?.post(url: url, parameters: newOrder, completionHandler: { statusCode in
            expectation.fulfill()
            XCTAssertEqual(statusCode, 201)
        })
        waitForExpectations(timeout: 5)
    }
    
    func testPostingDataShouldFail(){
        let expectation = expectation(description: "test creating customer")
        
        network = NetworkManager()
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        
        let newCustomer = Customer(email: "iyomnaothmann@yahoo.com", firstName: "Yomna", lastName: "Othman")
        network?.post(url: url, parameters: newCustomer, completionHandler: { statusCode in
            expectation.fulfill()
            XCTAssertEqual(statusCode, APIResponseCodes.badRequest.rawValue)
        })
        waitForExpectations(timeout: 5)
    }
    
}
