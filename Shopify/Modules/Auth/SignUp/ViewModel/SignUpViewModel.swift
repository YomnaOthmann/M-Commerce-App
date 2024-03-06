//
//  SignUpViewModel.swift
//  Shopify
//
//  Created by Mac on 03/03/2024.
//

import Foundation

protocol SignUpDelegate{
    func didRegistered(mail:String)
    func didFailToRegister(code:Int)
}

class SignUpViewModel{
    
    let defaults = UserDefaults.standard
    let network : NetworkManagerProtocol?
    var bindCustomer : ()->() = {}
    var delegate : SignUpDelegate?
    var customer : Customer?{
        didSet{
            bindCustomer()
        }
    }
    init(network: NetworkManagerProtocol?) {
        self.network = network
    }
    

    
    
    
    func postCustomer(mail:String, password:String, completionHandler:@escaping(Bool,String)->()){
        
        let firstname = mail.components(separatedBy: "@").first?.capitalized
        
        let newCustomer = NewCustomer(customer: Customer(id: 0, email: mail, createdAt: nil, updatedAt: nil, firstName: firstname, lastName: "", ordersCount: 0, state: nil, totalSpent: nil, lastOrderID: nil, verifiedEmail: true, taxExempt: nil, tags: password, lastOrderName: nil, currency: "EUR", phone: nil, addresses: nil, emailMarketingConsent: nil, smsMarketingConsent: nil, adminGraphqlAPIID: nil, defaultAddress:nil))
        
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        
        network?.post(url: url, parameters: newCustomer, completionHandler: {[weak self] statusCode in
            switch statusCode{
            case 201:
                self?.fetchCustomer(mail: mail) {[weak self] customer in
                    guard let customer = customer else{
                        self?.delegate?.didFailToRegister(code: 0)
                        return
                    }
                }
                //self?.delegate?.didRegistered(mail: mail)
                completionHandler(true,"Account Created Successfully")
            case 422:
                self?.delegate?.didFailToRegister(code: statusCode)
                completionHandler(false,"This account already exists")
            default:
                self?.delegate?.didFailToRegister(code: statusCode)
                completionHandler(false,"Failed to register your account")
            }
        })
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func fetchCustomer(mail:String, completionHandler:@escaping(Customer?)->()){
        let url  = APIHandler.baseUrl + APIHandler.APIEndPoints.customers.rawValue + APIHandler.APICompletions.json.rawValue
        network?.fetch(url: url, type: Customers.self, completionHandler: { [weak self] result in
            
            guard let customers = result else{
                completionHandler(nil)
                return
            }
            guard let customer = customers.customers?.filter({
                $0.email == mail
            }).first else{
                completionHandler(nil)
                return
            }
            self?.createWishlistDraftOrder(customer: customer, completionHandler: { wishCreated in
                if wishCreated{
                    print("wish creaaated")
                    self?.createCartDraftOrder(customer: customer, completionHandler: { cartCreates in
                        if wishCreated{
                            print("wish creaaated")
                            completionHandler(customer)
                            self?.delegate?.didRegistered(mail: customer.email ?? "")
                        }
                    })
                }else{
                    completionHandler(nil)
                    print("failure zaykkk")
                }
            })
            //print("sign \(customer.id)")
            let customerData = try? JSONEncoder().encode(customer)
            self?.defaults.set(customerData, forKey: "customer")
            self?.defaults.set(customer.email, forKey: "customerMail")
            self?.defaults.set(customer.id, forKey: "customerId")
        })
    }
    func createWishlistDraftOrder(customer:Customer,completionHandler:@escaping(Bool)->()){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + APIHandler.APICompletions.json.rawValue
        
        let cart = PostDraftOrder(draftOrder:
                                    DraftOrder(id: 0, note: nil, email: nil, taxesIncluded: nil, currency: nil, invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: true, completedAt: nil, name: "wish", status: nil, lineItems: [LineItem(name: "dummy", price: "0.0", productExists: false, productID: 0, quantity: 1, title: "dummy", totalDiscount: "0.0", taxLines: [], propertis: [])], shippingAddress: Address(id: 0, customerID: 0, address1: "", address2: "", city: "", province: "", country: "", zip: "", phone: "", name: "", provinceCode: "", countryCode: "", countryName: "", addressDefault: false), billingAddress: nil, invoiceURL: nil, orderID: nil, shippingLine: nil, tags: "wish", totalPrice: "0.0", subtotalPrice: "0.0", totalTax: nil, presentmentCurrency: nil, adminGraphqlAPIID: nil, customer: customer, appliedDiscount: nil)

        )
        network?.post(url: url, parameters: cart, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                print("cart created")
                completionHandler(true)
            default:
                print("cart failed")
                completionHandler(false)
            }
        })
    }
    func createCartDraftOrder(customer:Customer,completionHandler:@escaping(Bool)->()){
        let url = APIHandler.baseUrl + APIHandler.APIEndPoints.draftOrders.rawValue + APIHandler.APICompletions.json.rawValue
        
        let cart = PostDraftOrder(draftOrder:
                                    DraftOrder(id: 0, note: nil, email: nil, taxesIncluded: nil, currency: nil, invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: true, completedAt: nil, name: "cart", status: nil, lineItems:  [LineItem(name: "dummy", price: "0.0", productExists: false, productID: 0, quantity: 1, title: "dummy", totalDiscount: "0.0", taxLines: [], propertis: [])], shippingAddress: Address(id: 0, customerID: 0, address1: "", address2: "", city: "", province: "", country: "", zip: "", phone: "", name: "", provinceCode: "", countryCode: "", countryName: "", addressDefault: false), billingAddress: nil, invoiceURL: nil, orderID: nil, shippingLine: nil, tags: "cart", totalPrice: nil, subtotalPrice: nil, totalTax: nil, presentmentCurrency: nil, adminGraphqlAPIID: nil, customer: customer, appliedDiscount: nil)
        )
        network?.post(url: url, parameters: cart, completionHandler: { statusCode in
            switch statusCode{
            case 201:
                print("cart created")
                completionHandler(true)
            default:
                print("cart failed")
                completionHandler(false)
            }
        })
    }
    
    
}

