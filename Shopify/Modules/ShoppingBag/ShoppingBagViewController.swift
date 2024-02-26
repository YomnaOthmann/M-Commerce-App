//
//  ShoppingBagViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class ShoppingBagViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var checkoutContainer:UIView!
    var checkoutButton:ShoppingBagCustomButton!
    
    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addCheckButtonToView()
    }
    
    func addCheckButtonToView(){
        
        let frame = CGRect(x: screenWidth * 0.4, y: 20, width: viewWidth, height: 60)
        checkoutButton = ShoppingBagCustomButton(frame: frame).setTitleForButton(title: "Checkout")
        
        checkoutContainer.addSubview(checkoutButton)
    }
    
    
}
