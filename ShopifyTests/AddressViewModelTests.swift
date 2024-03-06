//
//  AddressViewModelTests.swift
//  ShopifyTests
//
//  Created by Faisal TagEldeen on 02/03/2024.
//

import XCTest
@testable import Shopify

final class AddressViewModelTests: XCTestCase {

    let addressVM:AddressViewModel = AddressViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
    }
    
    
    func testFetchAddressData(){
        
            let expectation = expectation(description: "test fetching AddressData")

            addressVM.dataObserver = {
                
                XCTAssert(self.addressVM.getAllAddress().isEmpty == false,"AddressVM data not fetched ")
                
                 expectation.fulfill()
            }
    
            addressVM.fetchData()
            waitForExpectations(timeout: 10)
    }
    
    
    func testSetCurrentAddressAtIndex(){
        
        let expectation = expectation(description: "test set current address at index to show in its data")

        addressVM.dataObserver = {
            
            self.addressVM.setCurrentAddressAtIndex(index: 0)
            XCTAssert(self.addressVM.getCustomerID() != 0,"AddressVM data not fetched ")
            expectation.fulfill()
        }
        
        addressVM.fetchData()
        waitForExpectations(timeout: 30)
    }
    
    func testIsDefaultAddressCashed(){
        
        let expectation = expectation(description: "test set isDefaultAddressCashed")

        addressVM.dataObserver = {
            
            XCTAssert(self.addressVM.isDefaultAddressCashed() == true,"Default Address isn't Cashed after fetch")
            
            expectation.fulfill()
        }
        
        addressVM.fetchData()
        waitForExpectations(timeout: 30)
        
        
    }
    
    func testSaveAddress(){
    
        addressVM.setAddressCountry(country:"USA")
               .setAddressCity(city: "Los Angeles")
               .setAddressProvince(province: "California")
               .setAddress(address: "321 Elm Street")
               .setAddressPhone(phone: "333-444-5555")
               .setAddressPostalCode(postalCode:"90001")
               .setDefaultValue(defaultAddress: false)
               .save { message, error in
                   
                   XCTAssertNil(error, "address not saved")
               }
        
    }
    
    
    func testEditAddress(){
        
        //there is at least one deafult address for customer
        
            let expectation = expectation(description: "test Edit Address work successfully")

            addressVM.dataObserver = {
                
            
                self.addressVM.setCurrentAddressAtIndex(index: 0)
                self.addressVM.edit(isEditNotSetDefault: true) { message, error in
                    
                    
                    XCTAssertNil(error, "address not edit")
                }
            
                expectation.fulfill()
            }
            
            addressVM.fetchData()
            waitForExpectations(timeout: 30)
    }

}
