//
//  Extensions.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import Foundation
import UIKit

extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
}

enum PaymentMethodSelector : String {
    case none = "none"
    case applePay = "applePay"
    case cash = "cash"
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
extension String{
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    func randomEmail() -> String {
        let nameLength = Int.random(in: 5...10)
        let domainLength = Int.random(in: 5...10)
        let domainSuffixes = ["com", "net", "org", "io", "co.uk"]
        let name = randomString(length: nameLength).lowercased()
        let domain = randomString(length: domainLength).lowercased()
        let randomDomainSuffixIndex = Int(arc4random_uniform(UInt32(domainSuffixes.count)))
        let domainSuffix = domainSuffixes[randomDomainSuffixIndex]
        let text = name + "@" + domain + "." + domainSuffix
        return text
    }

}
