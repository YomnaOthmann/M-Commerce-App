//
//  OrderSummaryCollectionViewCell.swift
//  Shopify
//
//  Created by Mac on 02/03/2024.
//

import UIKit

class OrderSummaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellPrice: UILabel!
    @IBOutlet weak var cellQuantity: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    static let id = "OrderSummaryCell"
    static func nib()->UINib{
        return UINib(nibName: "OrderSummaryCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
