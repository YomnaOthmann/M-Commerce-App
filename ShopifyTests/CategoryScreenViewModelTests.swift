//
//  CategoryScreenViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 26/02/2024.
//

import XCTest
@testable import Shopify
final class CategoryScreenViewModelTests: XCTestCase {
    
    let viewModel = CategoryScreenViewModel(network: NetworkManager())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCheckReachability(){
        let reachability = NetworkReachability.networkReachability
        XCTAssertTrue(reachability.networkStatus, "connection status is not satisfied")
    }
    
    func testFetchProducts(){
        let expectation = expectation(description: "test fetching products")
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            expectation.fulfill()
            XCTAssert(products.products.count > 0)
        }
        waitForExpectations(timeout: 5)
    }
    func testFilterProducts(){
        let expectation = expectation(description: "test filter products to sub categories")
        
        var allProducts : [Product] = []
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            allProducts = products.products
            let filtered = self.viewModel.filterProducts(products: allProducts, mainCategory: "men", subCategory: .shoes)
            var flag = true
            for item in filtered{
                if item.productType == .shoes{
                    flag = true
                }
                else{
                    flag = false
                    break
                }
            }
            expectation.fulfill()
            XCTAssertTrue(flag,"flag equal false")
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testGetAllItems(){
        let expectation = expectation(description: "test filter products to categories")
        
        var allProducts : [Product] = []
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            allProducts = products.products
            let filtered = self.viewModel.getAllItems(products:allProducts)
            expectation.fulfill()
            XCTAssert(filtered.count > 0, "filteration result count is not equal 30")
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testGetMenItems(){
        let expectation = expectation(description: "test filter products to categories")
        
        var allProducts : [Product] = []
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            allProducts = products.products
            let filtered = self.viewModel.getMenItems(products:allProducts)
            expectation.fulfill()
            XCTAssertEqual(filtered.count , 19, "filteration result count is not equal 30")
        }
        
        waitForExpectations(timeout: 5)
    }
    func testGetWomenItems(){
        let expectation = expectation(description: "test filter products to categories")
        
        var allProducts : [Product] = []
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            allProducts = products.products
            let filtered = self.viewModel.getWomenItems(products:allProducts)
            expectation.fulfill()
            XCTAssertEqual(filtered.count , 3, "filteration result count is not equal 30")
        }
        
        waitForExpectations(timeout: 5)
    }
    func testGetKidsItems(){
        let expectation = expectation(description: "test filter products to categories")
        
        var allProducts : [Product] = []
        viewModel.fetchProducts()
        viewModel.bindResult = {
            guard let products = self.viewModel.allProducts else{
                return
            }
            allProducts = products.products
            let filtered = self.viewModel.getKidsItems(products:allProducts)
            expectation.fulfill()
            XCTAssertEqual(filtered.count , 3, "filteration result count is not equal 30")
        }
        
        waitForExpectations(timeout: 5)
    }
    
}
