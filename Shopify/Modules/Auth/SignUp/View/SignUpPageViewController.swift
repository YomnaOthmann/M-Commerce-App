//
//  SignUpPageViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class SignUpPageViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let indicator = UIActivityIndicatorView(style: .medium)
    
    let viewModel = SignUpViewModel(network: NetworkManager())
    
    let defaults = UserDefaults.standard
    
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
    
    @IBAction func showHide(_ sender: UIButton) {
        
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
    
    @IBAction func showHideConfirm(_ sender: UIButton) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        if confirmPasswordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash") {
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        defaults.set(false, forKey: "isLogged")
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tab")
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
        
        indicator.startAnimating()
        
        // check text fields are not empty
        guard let email = userNameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirm = confirmPasswordTextField.text, !confirm.isEmpty else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "Missing data Fields")
            indicator.stopAnimating()
            return
        }
        
        // validate email are in the correct format
        guard viewModel.isValidEmail(email: email) else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "Invalid email format")
            indicator.stopAnimating()
            return
        }
        
        // validate password are in the correct format
        guard viewModel.validatePassword(password) else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "Invalid password format\nYour password must contain at least one character and one digit and be 8 characters long")
            indicator.stopAnimating()
            return
        }
        
        // check password and password confirmation are equal
        guard password == confirm else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "confirm password doesn't match")
            indicator.stopAnimating()
            return
        }
        
        // post new customer to API
        viewModel.postCustomer(mail: email, password: password, completionHandler: {[weak self] registered, message in
            if !registered{
                self?.indicator.stopAnimating()
                CustomAlert.showAlertView(view: self!, title: "Failed!!",message: "couldn't register")
            }
        })
        
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        let loginVC = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "login")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: false)
    }
    
    
}
extension SignUpPageViewController : SignUpDelegate{
    
    func didFailToRegister(code:Int) {
        indicator.stopAnimating()
        self.defaults.set(false, forKey: "isLogged")
        var message = ""
        switch code{
        case 422:
            message = "This account already exists"
        default:
            message = "An Error Occured"
        }
        CustomAlert.showAlertView(view: self, title: "Failed", message: message)
    }
    
    func didRegistered(mail:String) {
        self.indicator.stopAnimating()
        self.defaults.set(true, forKey: "isLogged")
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tab")
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: false)
        
    }
}




