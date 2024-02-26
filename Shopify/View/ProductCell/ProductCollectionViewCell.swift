//
//  ProductCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    static let id = "productCell"
    static func nib()->UINib{
        return UINib(nibName: "ProductCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        productImage.clipsToBounds = true
    }

}
