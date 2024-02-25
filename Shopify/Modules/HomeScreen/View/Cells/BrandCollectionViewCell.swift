//
//  BrandCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

   // @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    static let id = "brandCell"
    static func nib()->UINib{
        return UINib(nibName: "BrandCollectionViewCell", bundle: nil)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private func setShadow(){
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }

}
