//
//  CheckoutCustomButton.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 27/02/2024.
//

import Foundation

class CheckoutCustomButton: CustomButton {
    
    func setTitleForButton(title:String) -> CheckoutCustomButton{
        
        self.setTitle(title, for: .normal)
        return self
    }
    
}
