//
//  LoginViewController.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var Password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    

}
