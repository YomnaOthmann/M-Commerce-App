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
    let ok = UIAlertAction(title: "OK", style: .default)
    
    func showAlert(view:UIViewController){
        view.present(alert, animated: true)
    }
    func dismissAlert(){
        alert.dismiss(animated: true)
    }
    
    
}

class CustomAlert{
    static func showAlertView(view:UIViewController, title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        view.present(alert, animated: true)
    }
}
