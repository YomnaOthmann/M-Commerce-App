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
    private var country:String = "country"
    private var addressID:Int = 0
    private var customerID:Int = 0
    private var defaultAddress = false
    private var chacedDefaultAddressKey = "CachedDefaultAddressKey"
    
    var apiHandler = APIHandler()
    var networkManager:NetworkManagerProtocol? = NetworkManager()
    
    var dataObserver:()->Void = {}

    var addresses:[Address] = []{
        
        didSet{
            
            dataObserver()
        }
    }
    
    func fetchData(){
      
       let apiURL = apiHandler.getCustomerAddressURL(customerID: getCurrentUserID())
        networkManager?.fetch(url: apiURL, type: Addresses.self, completionHandler: {[weak self] addresses in
        
            if let addresses = addresses {
                
                for savedAddress in addresses.addresses ?? [] {

                    if savedAddress.addressDefault == true{
                        self?.cacheDefaultAddress(address: savedAddress)
                        break
                    }
                }
                
                self?.addresses = addresses.addresses ?? []
               }
        })
        
    }
    
    func cacheDefaultAddress(address:Address){
        
        do {
            let addressData = try JSONEncoder().encode(address)
            
            UserDefaults.standard.set(addressData, forKey: chacedDefaultAddressKey)
        } catch {
            print("Error encoding address: \(error.localizedDescription)")
        }
    }
    
    func isDefaultAddressCashed()->Bool{
    
        if let savedAddressData = UserDefaults.standard.data(forKey: chacedDefaultAddressKey) {
    
            do {
                let savedAddress = try JSONDecoder().decode(Address.self, from: savedAddressData)
                return true
            } catch {
                print("Error decoding address: \(error.localizedDescription)")
                return false
            }
        } else {
            print("No address data found in UserDefaults.")
            return false
        }
    }
    
    func setDeafultAddress(){
        
        if let savedAddressData = UserDefaults.standard.data(forKey: chacedDefaultAddressKey) {
            
            do {
                let savedAddress = try JSONDecoder().decode(Address.self, from: savedAddressData)
                
                country = savedAddress.country ?? "country"
                city = savedAddress.city ?? "city"
                province = savedAddress.province ?? "province"
                address = savedAddress.address1 ?? "address"
                phone = savedAddress.phone ?? "phone"
                postalCode = savedAddress.zip ?? "phone"
                addressID =  savedAddress.id ?? 0
                customerID =  savedAddress.customerID ?? 0
                defaultAddress = savedAddress.addressDefault ?? false
                
                
            } catch {
                print("Error decoding address: \(error.localizedDescription)")
            }
        } else {
            print("No address data found in UserDefaults.")
        }
        
    }

    func getCurrentUserID()->Int{
        return 7484106080498
    }

 func setCurrentAddressAtIndex(index:Int){

     country = addresses[index].country ?? "country"
     city = addresses[index].city ?? "city"
     province = addresses[index].province ?? "province"
     address = addresses[index].address1 ?? "address"
     phone = addresses[index].phone ?? "phone"
     postalCode = addresses[index].zip ?? "phone"
     addressID =  addresses[index].id ?? 0
     customerID =  addresses[index].customerID ?? 0
     defaultAddress = addresses[index].addressDefault ?? false
     
 }
    

    func getAddressesCountry()->String{
        
        return self.country
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

    func setAddressCountry(country:String)->AddressViewModel{
        self.country = country
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
    
    func setAddressToDefault(completion: @escaping (_ message:String?,_ error:Error?)->Void){
        self.edit(isEditNotSetDefault:false,completion: completion)
    }

    
    func save(completion:@escaping (_ message:String,_ error:Error?)->Void){
        
        let savedAddress = Address(id: nil, customerID: nil, address1: address, address2: nil, city: city, province: province, country: country, zip: postalCode, phone: phone, name: nil, provinceCode: nil, countryCode: nil, countryName: nil, addressDefault: defaultAddress)
        
        print("City: \(city)")
               print("Province: \(province)")
        print("Address: \(self.address)")
               print("Phone: \(phone)")
               print("Postal Code: \(postalCode)")
               print("Address ID: \(addressID)")
               print("Customer ID: \(customerID)")
               print("Default Address: \(defaultAddress)")
        print("country: \(country)")

        
        let addressPostModel = AddressPostModel(address: savedAddress)
        let apiURL = apiHandler.getNewAddressForCustomerURL(customerID: getCurrentUserID())
        
        print(apiURL)
        
        networkManager?.post(url: apiURL, parameters: addressPostModel,completionHandler: { statusCode in
            
            print(statusCode)
            
            if(statusCode == 200 || statusCode == 201){
                
                self.fetchData()
                self.dataObserver()
                completion("address saved successfully",nil)

            }else{
                completion("failed to save address changes",NSError())
            }
        })
        
    }
    
    func edit(isEditNotSetDefault:Bool,completion: @escaping (_ message:String,_ error:Error?)->Void){
        
        print("City: \(city)")
               print("Province: \(province)")
        print("Address: \(self.address)")
               print("Phone: \(phone)")
               print("Postal Code: \(postalCode)")
               print("Address ID: \(addressID)")
               print("Customer ID: \(customerID)")
               print("Default Address: \(defaultAddress)")
        print("country: \(country)")

        
        let updatedAddress = Address(id: addressID, customerID: customerID, address1: address, address2: nil, city: city, province: province, country: country, zip: postalCode, phone: phone, name: nil, provinceCode: nil, countryCode: nil, countryName: nil, addressDefault: defaultAddress)
        
        let addressPostModel = AddressPostModel(address: updatedAddress)
        
        let apiURL = apiHandler.getEditAddressURL(customerID: customerID, addressID: addressID)
        
        networkManager?.put(url: apiURL, parameters: addressPostModel,completionHandler: { statusCode in
            
            print(statusCode)
            
            if(statusCode == 200){
                                
                if(self.defaultAddress){
                    
                    print("cacheDefaultAddressfetchDatadataObserver")
                    self.cacheDefaultAddress(address: updatedAddress)
                    self.fetchData()
                    self.dataObserver()
                }
                
                if(isEditNotSetDefault){
                    
                    self.fetchData()
                    self.dataObserver()
                }
                
                completion("address saved successfully",nil)
            }else{
                completion("failed to save address changes",NSError())
            }
            
        })
    }
    
    func deleteAddress(completion:@escaping (_ message:String,_ error:Error?)->Void){
        
        let apiURL = apiHandler.getDeleteAddressURL(customerID: customerID, addressID: addressID)
        
        networkManager?.delete(url: apiURL, completionHandler: { statusCode in
            
            print(statusCode)
            
            if(statusCode == 200){
                                
                if(self.defaultAddress){
                    
                    UserDefaults.standard.removeObject(forKey:self.chacedDefaultAddressKey)
                    
                    self.fetchData()
                    self.dataObserver()
                }
                
                completion("address deleted successfully",nil)
            }else{
                completion("failed to delete address ",NSError())
            }
            
        })
        
    }
    
}

