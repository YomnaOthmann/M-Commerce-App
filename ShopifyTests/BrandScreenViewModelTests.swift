//
//  BrandScreenViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 25/02/2024.
//

import XCTest
@testable import Shopify
final class BrandScreenViewModelTests: XCTestCase {
let viewModel = BrandScreenViewModel(network: NetworkManager())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        // Put the code you want to measure the time of here.
        
    func testFetchBrands(){
        
        let expectation = expectation(description: "test fetching products")
        viewModel.fetchProducts(brandName: "ADIDAS")
        viewModel.bindResult = {
            guard let products = self.viewModel.brandProducts else{
                expectation.fulfill()
                XCTFail("Products equal nil")
                return
            }
            expectation.fulfill()
            XCTAssert(products.count > 0 , "Products equal zero")
        }
        waitForExpectations(timeout: 5)
    }
    
    func testFetchBrandsShoulsFail(){
        let expectation = expectation(description: "test fetching products to fail")
        viewModel.fetchProducts(brandName: "ABIBAS")
        viewModel.bindResult = {
            guard let products = self.viewModel.brandProducts else{
                return
            }
            expectation.fulfill()
            XCTAssertEqual(self.viewModel.brandProducts?.count, 0,"Products equal nil")        }
        waitForExpectations(timeout: 5)
    }
    
    func testReachability(){
        let reachability = NetworkReachability.networkReachability
        XCTAssertTrue(reachability.networkStatus, "Not Reachable")
    }
    
    

}
