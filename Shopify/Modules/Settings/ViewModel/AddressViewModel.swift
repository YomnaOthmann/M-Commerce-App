//
//  AddressViewModel.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 29/02/2024.
//

import Foundation

class AddressViewModel{
 
   private var city:String = "city"
   private var province:String = "province"
   private var address:String = "address"
   private var phone:String = "phone"
   private var postalCode:String = "postalCode"
   private var addressID:Int = 0
   private var customerID:Int = 0
   private var defaultAddress = false

   var dataObserver:()->Void = {}

    var addresses:[Address] = []{
        didSet{
            
            dataObserver()
        }
    }
    
    func fetchData(){
      
        addresses = [Address(id: 1234, customerID: 5678, address1: "123 Main Street", address2: "Apt 101", city: "New York", province: "New York", country: "USA", zip: "10001", phone: "123-456-7890", name: "John Doe", provinceCode: "NY", countryCode: "US", countryName: "United States", addressDefault: true),
                     Address(id: 9876, customerID: 5432, address1: "456 Elm Street", address2: nil, city: "Los Angeles", province: "California", country: "USA", zip: "90001", phone: "555-123-4567", name: "Jane Smith", provinceCode: "CA", countryCode: "US", countryName: "United States", addressDefault: false)
        ]
    }
    

    func getCurrentUserID()->Int{
        return 123
    }

 func setCurrentAddressAtIndex(index:Int){
     
     city = addresses[index].city ?? "city"
     province = addresses[index].province ?? "province"
     address = addresses[index].address1 ?? "address"
     phone = addresses[index].phone ?? "phone"
     postalCode = addresses[index].zip ?? "phone"
     addressID =  addresses[index].id ?? 0
     customerID =  addresses[index].customerID ?? 0
     defaultAddress = addresses[index].addressDefault ?? false
     
 }
    
  func getAddressesCount()->Int{
      
       return addresses.count
  }
        
  func getAddressID()->Int{
        return addressID
  }

  func getCustomerID()->Int{
        return customerID
  }

  func getAddressCity()->String{
        return city
  }
     
  func getAddressProvince()->String{
        return province
  }
    
  func getAddress()->String{
        return address
  }
    
  func getAddressPhone()->String{
        return phone
  }
    
  func getAddressPostalCode()->String{
        return postalCode
  }
    
  func getDefaultValue()->Bool{
        return defaultAddress
  }
  
  func setAddressID(id:Int)->AddressViewModel{
        self.addressID = id
        return self
  }
    
   func setCustomerID(id:Int)->AddressViewModel{
        self.customerID = id
        return self
   }

   func setAddressCity(city:String)->AddressViewModel{
        self.city = city
        return self
   }
    
   func setAddressProvince(province:String)->AddressViewModel{
        self.province = province
        return self
   }
   func setAddress(address:String)->AddressViewModel{
        self.address = address
        return self
   }
   func setAddressPhone(phone:String)->AddressViewModel{
        self.phone = phone
        return self
   }
    
   func setAddressPostalCode(postalCode:String)->AddressViewModel{
        self.postalCode = postalCode
        return self
   }
   
    func setDefaultValue(defaultAddress:Bool)->AddressViewModel{
        self.defaultAddress = defaultAddress
        return self
    }
    
    func setAddressToDefault(completion:(_ message:String?,_ error:Error?)->Void){
        
        self.edit(completion: completion)
    }

    
    func save(completion:(_ message:String,_ error:Error?)->Void){
        
        let address = Address(id: nil, customerID: nil, address1: address, address2: nil, city: city, province: province, country: nil, zip: postalCode, phone: phone, name: nil, provinceCode: nil, countryCode: nil, countryName: nil, addressDefault: defaultAddress)
        
        print("City: \(city)")
               print("Province: \(province)")
        print("Address: \(self.address)")
               print("Phone: \(phone)")
               print("Postal Code: \(postalCode)")
               print("Address ID: \(addressID)")
               print("Customer ID: \(customerID)")
               print("Default Address: \(defaultAddress)")
        
        let addressPostModel = AddressPostModel(address: address)
        
        
        completion("address saved successfully",nil)
    }
    
    
    
    func edit(completion:(_ message:String,_ error:Error?)->Void){
        
        let address = Address(id: addressID, customerID: customerID, address1: address, address2: nil, city: city, province: province, country: nil, zip: postalCode, phone: phone, name: nil, provinceCode: nil, countryCode: nil, countryName: nil, addressDefault: defaultAddress)
        
        let addressPostModel = AddressPostModel(address: address)
        
        completion("address saved successfully",nil)
    }
    
    
    
    func deleteAddresAtIndex(index:Int){
        addresses.remove(at: index)
        dataObserver()
    }
    
}

