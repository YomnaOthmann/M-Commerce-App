//
//  FilterCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterImage: UIImageView!
    
    static let id = "filter"
    static func nib()->UINib{
        return UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        filterImage.layer.cornerRadius = filterImage.frame.width / 2 
    }

}
