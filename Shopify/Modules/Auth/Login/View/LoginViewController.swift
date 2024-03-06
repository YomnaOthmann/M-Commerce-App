//
//  LoginViewController.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let indicator = UIActivityIndicatorView(style: .medium)
    let defaults = UserDefaults.standard
    let viewModel = LoginViewModel(network: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIndicator()
        viewModel.delegate = self
    }

    func setUpIndicator(){
        indicator.center = view.center
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
    @IBAction func ShowandHidePass(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
            if passwordTextField.isSecureTextEntry {
                if let image = UIImage(systemName: "eye") {
                    sender.setImage(image, for: .normal)
                }
            } else {
                if let image = UIImage(systemName: "eye.slash") {
                    sender.setImage(image, for: .normal)
                }
            }
        
    }
    
    @IBAction func login(_ sender: Any) {
        indicator.startAnimating()
        guard let email = userNameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            CustomAlert.showAlertView(view: self, title: "Unable to Login", message: "Missing data Fields")
            indicator.stopAnimating()
            return
        }
        viewModel.fetchCustomer(mail: email, password: password)
    }


    @IBAction func gotoSignUp(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
   
    @IBAction func skip(_ sender: Any) {
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tab")
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: true)
    }
}

extension LoginViewController : LoginViewModelDelegate{
    func failedToLogin() {
        indicator.stopAnimating()
        CustomAlert.showAlertView(view: self, title: "Failed", message: "User Not Found")
    }

    func didRetrieveCustomer(customer:Customer) {
        indicator.stopAnimating()
        defaults.set(true, forKey: "isLogged")
        defaults.set(customer.id, forKey: "customerId")
        defaults.set(customer.email, forKey: "customerMail")
        print("from login view")
        print(defaults.integer(forKey: "customerId"))
        performSegue(withIdentifier: "home", sender: self)
    }
}
