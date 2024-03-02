//
//  AddressCustomButton.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import Foundation
import UIKit

class AddressCustomButton : CustomButton {
    
    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.9
    }
    
    func setupConstraints()-> AddressCustomButton {
        
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        widthAnchor.constraint(equalToConstant:(viewWidth)).isActive = true
            
        return self
    }
    
    func setTitleForButton(title:String) -> AddressCustomButton {
        
        self.setTitle(title, for: .normal)
        return self
    }
    
}
