//
//  SignUpViewModelTests.swift
//  ShopifyTests
//
//  Created by Mac on 03/03/2024.
//

import XCTest
@testable import Shopify
final class SignUpViewModelTests: XCTestCase {

    let viewModel = SignUpViewModel(network: NetworkManager())
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidateEmail(){
        
        XCTAssertTrue(viewModel.isValidEmail(email: "yomnaothman@gmail.com"), "This email is not valid")
    }
    func testValidateEmailShouldFail(){
        XCTAssertFalse(viewModel.isValidEmail(email: "yomnaothmangmail..com"), "This email is valid")
    }
    
    func testValidatePassword(){
        XCTAssertTrue(viewModel.validatePassword("1234Yomna"), "this password is not valid")
    }
    func testValidatePasswordShouldFail(){
        XCTAssertFalse(viewModel.validatePassword("123y"), "this password is valid")
    }
    func testPostingNewCustomer(){
        let expectation = expectation(description: "post new customer")
        let email = String().randomEmail()
        viewModel.postCustomer(mail: email, password: "123454tr") { registered, message in
            expectation.fulfill()
            XCTAssertTrue(registered, "failed to register")
        }
        waitForExpectations(timeout: 5)
    }
    
    func testFetchingCustomer(){
        let expectation = expectation(description: "fetch customer")
        viewModel.fetchCustomer(mail: "lotfy@gmail.com") { result in
            guard let customer = result else{
                return
            }
            expectation.fulfill()
            XCTAssert(customer.email == "lotfy@gmail.com")
        }
        waitForExpectations(timeout: 5)
    }
    func testCreateDraftOrder(){
        let expectation = expectation(description: "create draft")
        let customer = Customer(email: "yomna@example.com", createdAt: "", updatedAt: "", firstName: "Yomna", lastName: "Othman", ordersCount: 0, state: "", totalSpent: "", lastOrderID: 0, verifiedEmail: false, tags: "", lastOrderName: "", currency: "", phone: "", addresses: [], emailMarketingConsent: nil, smsMarketingConsent: nil, adminGraphqlAPIID: "", defaultAddress: nil)
        
        viewModel.createCartDraftOrder(customer: customer) { created in
            expectation.fulfill()
            XCTAssertTrue(created)
        }
        waitForExpectations(timeout: 5)
    }

}
