//
//  SignUpPageViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit
import FirebaseAuth
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
        
    }
    func setUpIndicator(){
        indicator.center = view.center
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
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
        guard let email = userNameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirm = confirmPasswordTextField.text, !confirm.isEmpty else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "Missing data Fields")
            indicator.stopAnimating()
            return
        }
        guard validatePassword(password) else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: """
            Invalid password format
            Your password must contain:
            - At least one uppercase letter
            - At least one lowercase letter
            - At least one digit
            - At least 8 characters long
""")
            indicator.stopAnimating()
            return
        }
        guard password == confirm else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "confirm password doesn't match")
            indicator.stopAnimating()
            return
        }
        guard isValidEmail(email: email) else{
            CustomAlert.showAlertView(view: self, title: "Unable to resgister", message: "Invalid email format")
            indicator.stopAnimating()
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            guard let self = self else{
                return
            }
            guard error == nil else{
                self.defaults.set(true, forKey: "isLogged")
                self.indicator.stopAnimating()
                self.performSegue(withIdentifier: "home", sender: self)
                return
            }
            indicator.stopAnimating()
            CustomAlert.showAlertView(view: self, title: "Failed", message: error?.localizedDescription ?? "")
            
        }
        
        
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
    
    @IBAction func googleRegister(_ sender: Any) {
        
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: self)

    }
    

}
