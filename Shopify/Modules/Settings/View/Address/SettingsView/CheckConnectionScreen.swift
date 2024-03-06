//
//  CheckConnectionScreen.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 06/03/2024.
//

import UIKit

class CheckConnectionScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tryAgain(_ sender: Any) {
                   
             self.dismiss(animated: true, completion: nil)
    
        print("NetworkReachability.networkReachability.networkStatus")
        print("\(NetworkReachability.networkReachability.networkStatus)")
    }
}
