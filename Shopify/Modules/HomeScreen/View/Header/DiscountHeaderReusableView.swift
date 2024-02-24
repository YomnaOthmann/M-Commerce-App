//
//  HeaderReusableView.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class DiscountHeaderReusableView: UICollectionReusableView {
    static let id = "DiscountHeaderReusableView"
   
    @IBOutlet weak var headerLabel: UILabel!
    
}

class BrandHeadeReusableView : UICollectionReusableView{
    static let id  = "BrandHeadeReusableView"
    
    @IBOutlet weak var brandLabel: UILabel!

}
