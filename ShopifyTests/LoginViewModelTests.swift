//
//  LoginViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 06/03/2024.
//

import XCTest
@testable import Shopify
final class LoginViewModelTests: XCTestCase {

    let viewModel = LoginViewModel(network: NetworkManager())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchingCustomer(){
        let expectation = expectation(description: "fetch customer")
        viewModel.fetchCustomer(mail: "lotfy@gmail.com", password: "lotfy1234") { result in
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
        viewModel.fetchCustomer(mail: "lotf@gmail.com", password: "lotfy1234") { result in
            guard let customer = result else{
                expectation.fulfill()
                XCTAssertNil(result,"customer is not equal nil")
                return
            }
        }
        waitForExpectations(timeout: 5)
    }


}
