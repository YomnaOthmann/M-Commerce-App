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
        
        shoppingBagViewModel?.quantityExceedLimitObserver = {message in
            
            CustomAlert.showAlertView(view: self, title: "Limit Exceeded", message: message)
            
        }
        
        shoppingBagViewModel?.lowestQuantityDecrementObserver = {message,index in
            
            self.deleteProductAtIndexAlert(message: message, index: index)
            
        }
        
        shoppingBagViewModel?.fetchData()
    }
    
    func deleteProductAtIndexAlert(message:String,index:Int){
        
        let alertController = UIAlertController(title: "Delete Product", message: message, preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.shoppingBagViewModel?.deleteLineItem(atIndex: index)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    func addCheckButtonToView(){
        
        let frame = CGRect(x: screenWidth * 0.4, y: 20, width: viewWidth, height: 50)
        checkoutButton = ShoppingBagCustomButton(frame: frame).setTitleForButton(title: "Checkout")
        
        checkoutContainer.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(navigateToCheckout), for: .touchUpInside)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @objc func navigateToCheckout(){
        
        if shoppingBagViewModel?.getLineItmesCount() == 0 {
            CustomAlert.showAlertView(view: self, title: "To Checkout Status", message: "Can't Continue to Checkout the Shopping Bag is empty")
        }else{
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
            
            let checkoutViewModel = CheckoutViewModel()
            let addressViewModel = AddressViewModel()
            
            checkoutViewModel.lineItems = shoppingBagViewModel?.getLineItems() ?? []
            checkoutViewModel.lineItemsTotalPrice = shoppingBagViewModel?.getLineItemsTotalPrice()
            
            viewController.checkoutViewModel = checkoutViewModel
            viewController.addressViewModel = addressViewModel
            
            self.present(viewController, animated: true, completion: nil)

        }

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
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.deleteProductAtIndexAlert(message: "do you want to delete this product", index: indexPath.row)
        }
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
