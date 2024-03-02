//
//  LoginViewController.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    var signInVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        let signupVC = SignUpPageViewController()
        
        self.navigationController?.pushViewController(signupVC, animated: true)
        
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let password = Password.text, !password.isEmpty else{
            print("Missing Field Data") // alert
            let alert = UIAlertController(title: "Missing Field Data", message: "Please Enter Data in The Missing Fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    
        
        
        @IBAction func ShowandHidePass(_ sender: UIButton) {
            Password.isSecureTextEntry.toggle()
            if Password.isSecureTextEntry {
                if let image = UIImage(systemName: "eye") {
                    sender.setImage(image, for: .normal)
                }
            } else {
                if let image = UIImage(systemName: "eye.slash") {
                    sender.setImage(image, for: .normal)
                }
            }
            
        }
    
    func getCustomerIDFromAPI(userEmail: String, completion: @escaping () -> Void){
        self.signInVM.getCustomerId(email: userEmail) { result in
            switch result {
            case .success(let customerId):
                let customerrId = customerId
                if customerId.customers.contains(where: { $0.email == userEmail
                }){
                    completion()
                    print("Customer ID: \(customerrId)")

                    if let customerID = UserDefaults.standard.value(forKey: "customerID") {
                       
                        print("Customer ID: \(customerID)")
                    } else {
                        
                        print("Customer ID is not available")
                    }
                }

            case .failure(let error):
                print("Failed to retrieve customer ID: \(error)")
            }
        }
    }
        
        
    }

