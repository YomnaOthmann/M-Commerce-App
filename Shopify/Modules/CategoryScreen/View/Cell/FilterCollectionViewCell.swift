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
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.layer.cornerRadius = 40
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.customBlue.cgColor
            }
            else {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.customBlue.cgColor
            }
        }
    }
    static func nib()->UINib{
        return UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        filterImage.layer.cornerRadius = filterImage.frame.width / 2 
    }

}
