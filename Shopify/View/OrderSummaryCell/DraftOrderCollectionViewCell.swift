//
//  DraftOrderCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 29/02/2024.
//

import UIKit

class DraftOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellPrice: UILabel!
    @IBOutlet weak var cellQuantity: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    static let id = "draftOrderCell"
    static func nib()->UINib{
        return UINib(nibName: "DraftOrderCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
