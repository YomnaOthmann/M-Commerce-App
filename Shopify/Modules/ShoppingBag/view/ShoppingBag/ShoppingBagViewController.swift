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
    
    
    @IBOutlet weak var lineItemsTotalPrice: UILabel!
    
    var checkoutButton:ShoppingBagCustomButton!
    let shoppingBagViewModel:ShoppingBagViewModel? = ShoppingBagViewModel()
    
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
        
        shoppingBagViewModel?.dataObserver = {[weak self] in
            
            self?.lineItemsTotalPrice.text = self?.shoppingBagViewModel?.getLineItemsTotalPrice()
            
            self?.productsTableView.reloadData()
        }
        shoppingBagViewModel?.fetchData()
    }
    
    func addCheckButtonToView(){
        
        let frame = CGRect(x: screenWidth * 0.4, y: 20, width: viewWidth, height: 50)
        checkoutButton = ShoppingBagCustomButton(frame: frame).setTitleForButton(title: "Checkout")
        
        checkoutContainer.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(navigateToCheckout), for: .touchUpInside)
        
    }
    
    @objc func navigateToCheckout(){
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        
        let checkoutViewModel = CheckoutViewModel()
        checkoutViewModel.lineItems = shoppingBagViewModel?.getLineItems() ?? []
        checkoutViewModel.lineItemsTotalPrice = shoppingBagViewModel?.getLineItemsTotalPrice()
        
        viewController.checkoutViewModel = checkoutViewModel
        
        self.present(viewController, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shoppingBagViewModel?.getLineItmesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingBagCell", for: indexPath) as! ShoppingBagCustomCell
    
        
        cell.increaseButton.setIndex(index:indexPath.row)
        cell.increaseButton.addTarget(self, action: #selector(inCreaseQuantity), for: .touchUpInside)
        
        cell.decreaseButton.setIndex(index: indexPath.row)
        cell.decreaseButton.addTarget(self, action: #selector(deCreaseQuantity), for: .touchUpInside)
        
        cell.productTitle.text = shoppingBagViewModel?.getLineItemTitle(atIndex: indexPath.row)
        
        cell.productSubTitle.text = shoppingBagViewModel?.getLineItemSubTitle(atIndex: indexPath.row)

        cell.amountPrice.text = shoppingBagViewModel?.getLineItemTotalPrice(atIndex: indexPath.row)
        
        cell.productAmount.text = shoppingBagViewModel?.getLineItemQuantity(atIndex: indexPath.row)
    
        cell.inStockQuantity.text = shoppingBagViewModel?.getLineItemInStockQuantity(atIndex: indexPath.row)
        
        cell.deliverDate.text = shoppingBagViewModel?.getLineItemDeliverBy(atIndex: indexPath.row)
        
        return cell
    }
    
    @objc func inCreaseQuantity(sender:CustomCellButton){
        
        print("inCreaseQuantity")
        print(sender.getIndex())
        
        shoppingBagViewModel?.increaseLineItemQuantity(atIndex: sender.getIndex())
        
    }
    
    @objc func deCreaseQuantity(sender:CustomCellButton){
        
        print("deCreaseQuantity")
        print(sender.getIndex())
        shoppingBagViewModel?.decreaseLineItemQuantity(atIndex: sender.getIndex())
    }
    
}
