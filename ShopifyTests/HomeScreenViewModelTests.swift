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

}
