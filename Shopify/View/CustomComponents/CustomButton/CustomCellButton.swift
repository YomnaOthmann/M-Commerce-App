//
//  CustomCellButton.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 01/03/2024.
//

import Foundation
import Foundation
import UIKit

class CustomCellButton : UIButton {
    
    var cellIndex:Int?
    
    func setIndex(index:Int){
        self.cellIndex = index
    }
    
    func getIndex()->Int{
        return self.cellIndex ?? 0
    }
}
