//
//  CustomSpacerView.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import Foundation
import UIKit

class CustomSpacerView : UIView{
    
    override init(frame: CGRect){
        super.init(frame: frame)
                 
        heightAnchor.constraint(equalToConstant:70).isActive = true
        widthAnchor.constraint(equalToConstant:(50)).isActive = true

    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
}
