//
//  NotLoggedMeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class NotLoggedMeScreenViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        let loginVC = UIStoryboard(name: "LoginPage", bundle: nil).instantiateViewController(withIdentifier: "login")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: false)
    }
    
}
