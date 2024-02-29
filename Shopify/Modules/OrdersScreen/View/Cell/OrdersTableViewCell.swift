//
//  OrdersTableViewCell.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderItemsQuantity: UILabel!
  
    @IBOutlet weak var orderFinancialState: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    static let id = "orderCell"
    
    static func nib()->UINib{
        return UINib(nibName: "OrdersTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setShadow(){
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 4, height: -4)
    }
    
}
