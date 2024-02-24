//
//  BrandCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    static let id = "brandCell"
    static func nib()->UINib{
        return UINib(nibName: "BrandCollectionViewCell", bundle: nil)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        brandImage.layer.cornerRadius = 75
        brandImage.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
