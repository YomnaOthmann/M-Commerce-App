//
//  ShoppingBagCustomCell.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class ShoppingBagCustomCell: UITableViewCell {

    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productSubTitle: UILabel!
    
    @IBOutlet weak var amountPrice: UILabel!
    
    @IBOutlet weak var productAmount: UILabel!
    
    @IBOutlet weak var inStockQuantity: UILabel!
    
    @IBOutlet weak var deliverDate: UILabel!
    
    @IBOutlet weak var increaseButton: CustomCellButton!
    
    @IBOutlet weak var decreaseButton: CustomCellButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

class CustomCellButton : UIButton {
    
    var cellIndex:Int?
    
    func setIndex(index:Int){
        self.cellIndex = index
    }
    
    func getIndex()->Int{
        return cellIndex ?? 0
    }
}


