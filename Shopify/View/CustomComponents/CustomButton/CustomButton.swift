//
//  CustomButton.swift
//  Shopify
//
//  Created by Mac on 21/02/2024.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    func setUpButton(){
        
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = .customBlue
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "MontserratSemiBold", size: 20)
        
    }
    

}
