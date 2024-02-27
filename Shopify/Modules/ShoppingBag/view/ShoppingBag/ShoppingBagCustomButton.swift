//
//  ShoppingBagCustomButton.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 26/02/2024.
//

import Foundation
import UIKit

class ShoppingBagCustomButton : CustomButton {
    
    func setTitleForButton(title:String) -> ShoppingBagCustomButton{
        
        self.setTitle(title, for: .normal)
        return self
    }
    
}

