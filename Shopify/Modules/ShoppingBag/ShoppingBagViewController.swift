//
//  ShoppingBagViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class ShoppingBagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var checkoutContainer:UIView!
    var checkoutButton:ShoppingBagCustomButton!
    
    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.delegate=self
        productsTableView.dataSource=self
        
        productsTableView.rowHeight = 180
        
        addCheckButtonToView()
    }
    
    func addCheckButtonToView(){
        
        let frame = CGRect(x: screenWidth * 0.4, y: 20, width: viewWidth, height: 50)
        checkoutButton = ShoppingBagCustomButton(frame: frame).setTitleForButton(title: "Checkout")
        
        checkoutContainer.addSubview(checkoutButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingBagCell", for: indexPath) as! ShoppingBagCustomCell

        return cell
    }
    
    
}
