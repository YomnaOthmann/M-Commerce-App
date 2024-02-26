//
//  DeliveryAddressSettingCustomCell.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class DeliveryAddressSettingCustomCell: UITableViewCell {

    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        mainBackground.layer.cornerRadius = 8
        mainBackground.backgroundColor = .white
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 3

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

    
    
}