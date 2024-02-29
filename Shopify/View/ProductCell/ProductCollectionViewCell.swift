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
        productImage.clipsToBounds = true
        setShadow()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadow()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShadow()
    }
    func setShadow(){
        self.layer.shadowColor = UIColor.secondaryLabel.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: -4, height: 4)
        self.layer.shadowOpacity = 0.3
    }

}
