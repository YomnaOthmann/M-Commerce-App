//
//  SignUpPageViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SignUpPageViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    
    let signUp = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else{
            print("Missing Field Data") // alert
            let alert = UIAlertController(title: "Missing Field Data", message: "Please Enter Data in The Missing Fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return
        }
        
        if !isValidPassword(password) {
            showAlert(title: "Invalid Password", message: "Password must meet certain criteria")
            return
        }
        
        signUp.createAccount(email: email, password: password)
        signUp.create(email: email, password: password) { result in
            switch result {
            case .success(let customer):
                print("debug1 \(customer)")
                
                self.showSuccessAlert()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    @IBAction func LoginButton(_ sender: Any) {
        
        let signinVC = LoginViewController()
     
        self.navigationController?.popViewController(animated: true)
    }
    
  
        func isValidEmail(_ email: String) -> Bool {
         
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

        
        func isValidPassword(_ password: String) -> Bool {
            
            return password.count >= 6
        }

        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        
        func showSuccessAlert() {
            let alert = UIAlertController(title: "Account Created Successfully!", message: "What would you like to do?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default) { _ in
                
                let signinVC = LoginViewController()
                self.navigationController?.pushViewController(signinVC, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    
    func createGoogleAccount(userEmail: String, completion: @escaping () -> Void){
        self.signUp.create(email: userEmail, password: passwordField.text ?? "") { result in
            completion()
            switch result {
            case .success(let customer):
                print("debug1 \(customer)")
                
            case .failure(let error):
                print("Create Google Account \(error)")
            }
        }
    }
    
    func getCustomerIDFromAPI(userEmail: String, completion: @escaping () -> Void){
        self.signUp.getCustomerId(email: userEmail) { result in
            switch result {
            case .success(let customerId):
                let customerrId = customerId
                if customerId.customers.contains(where: { $0.email == userEmail
                }){
                    completion()
                    print("Customer ID: \(customerrId)")

                    if let customerID = UserDefaults.standard.value(forKey: "customerID") {
                        // Use the customerID
                        print("Customer ID: \(customerID)")
                    } else {
                        // Customer ID is not available in UserDefaults
                        print("Customer ID is not available")
                    }
                }else{
                    self.createGoogleAccount(userEmail: userEmail, completion: completion)
                }

            case .failure(let error):
                print("Failed to retrieve customer ID: \(error)")
            }
        }
    }
    
    
    @IBAction func ShowandHidePassword(_ sender: UIButton) {
        
        passwordField.isSecureTextEntry.toggle()
            if passwordField.isSecureTextEntry {
                if let image = UIImage(systemName: "eye") {
                    sender.setImage(image, for: .normal)
                }
            } else {
                if let image = UIImage(systemName: "eye.slash") {
                    sender.setImage(image, for: .normal)
                }
            }
    }
    
    
    @IBAction func confirmPassword(_ sender: UIButton) {
        
        confirmPassword.isSecureTextEntry.toggle()
            if confirmPassword.isSecureTextEntry {
                if let image = UIImage(systemName: "eye") {
                    sender.setImage(image, for: .normal)
                }
            } else {
                if let image = UIImage(systemName: "eye.slash") {
                    sender.setImage(image, for: .normal)
                }
            }
    }
    
    
    
    
    
}
    

