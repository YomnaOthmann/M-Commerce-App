//
//  AdsCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit

class AdsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adDescription: UILabel!
    
    static let id = "adCell"
    static func nib()->UINib{
        return UINib(nibName: "AdsCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 30
    }

}
