//
//  Alert.swift
//  Shopify
//
//  Created by Mac on 22/02/2024.
//

import Foundation
import UIKit

class ConnectionAlert{
    let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection", preferredStyle: .alert)
    
    func showAlert(view:UIViewController){
        view.present(alert, animated: true)
    }
    
}
