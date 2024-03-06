//
//  HomeScreenViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 25/02/2024.
//

import XCTest
@testable import Shopify
final class HomeScreenViewModelTests: XCTestCase {

    let homeScreenViewModel = HomeScreenViewModel(network: NetworkManager())
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAds(){
        let expectation = expectation(description: "test fetching ads")
    
        homeScreenViewModel.fetchAds()
        homeScreenViewModel.bindResult = {
            expectation.fulfill()
            XCTAssertNotNil(self.homeScreenViewModel.ads, "Ads equal nil")
        }

        waitForExpectations(timeout: 5)
    }

    
    func testFetchBrands(){
        let expectation = expectation(description: "test fetching brands")
    
        homeScreenViewModel.fetchBrands()
        homeScreenViewModel.bindResult = {
            expectation.fulfill()
            XCTAssertNotNil(self.homeScreenViewModel.brands, "brands equal nil")
        }

        waitForExpectations(timeout: 5)
    }
    
    func testFetchingDiscountCodes(){
        let expectation = expectation(description: "test fetching discount codes")
        homeScreenViewModel.fetchDiscountCodes(priceRuleId: 1376067420402)
        homeScreenViewModel.bindResult = {
            expectation.fulfill()
            XCTAssertNotNil(self.homeScreenViewModel.discountCodes, "discountCodes equal nil")
        }

        waitForExpectations(timeout: 5)
    }
    func testFetchingCustomer(){
        let expectation = expectation(description: "fetch customer")
        homeScreenViewModel.fetchCustomer(mail: "lotfy@gmail.com") { result in
            guard let customer = result else{
                return
            }
            expectation.fulfill()
            XCTAssertNotNil(customer,"customer equal nil")
        }
        waitForExpectations(timeout: 5)
    }
    func testFetchingCustomerEqualNil(){
        let expectation = expectation(description: "fetching customer")
        homeScreenViewModel.fetchCustomer(mail: "lotf@gmail.com") { result in
            guard let customer = result else{
                expectation.fulfill()
                XCTAssertNil(result,"customer is not equal nil")
                return
            }
        }
        waitForExpectations(timeout: 5)
    }
    
    func testCheckReachability(){
        XCTAssertTrue(homeScreenViewModel.checkReachability(), "not reachable")
    }
    func testFetchingDraftOrder(){
        let expectation = expectation(description: "fetching customer")

        homeScreenViewModel.fetchWishlistAndCart { wish, cart in
            var drafts : [DraftOrder] = []
            guard let cart = cart else{
                expectation.fulfill()
                XCTAssertNil(cart, "cart is not nil")
                return
            }
            drafts.append(cart)
            guard let wish = wish else{
                expectation.fulfill()
                XCTAssertNil(wish, "wish is not nil")
                return
            }
            drafts.append(wish)
            expectation.fulfill()
            XCTAssert(drafts.count == 2, "drafts count are not equal 2")
            
        }
        waitForExpectations(timeout: 5)
    }

}
