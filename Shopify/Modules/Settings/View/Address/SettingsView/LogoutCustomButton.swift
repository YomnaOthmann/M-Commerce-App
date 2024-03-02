//
//  LogoutCustomButton.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 27/02/2024.
//

import Foundation

class LogoutCustomButton : CustomButton {
    
    func setTitleForButton(title:String) -> LogoutCustomButton {
        
        self.setTitle(title, for: .normal)
        return self
    }
}
