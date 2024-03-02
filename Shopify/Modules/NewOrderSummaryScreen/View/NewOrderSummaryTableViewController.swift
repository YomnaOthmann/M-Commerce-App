//
//  NewOrderSummaryTableViewController.swift
//  Shopify
//
//  Created by Mac on 02/03/2024.
//

import UIKit
import PassKit

class NewOrderSummaryTableViewController: UITableViewController {
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var orderSubtotal: UILabel!
    @IBOutlet weak var orderDiscount: UILabel!
    @IBOutlet weak var orderTax: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    
    
    @IBOutlet weak var orderAddress: UILabel!
    @IBOutlet weak var orderContact: UILabel!
    
    @IBOutlet weak var orderItemsCollectionView: UICollectionView!
    var order : Order?
    var paymentMethod : PaymentMethodSelector?
    let viewModel = NewOrderSummaryViewModel(network: NetworkManager())
        private var paymentRequest:PKPaymentRequest = {
    
           let request = PKPaymentRequest()
           request.merchantIdentifier = "merchant.com.faisaltag.pay"
           request.supportedNetworks = [.visa,.masterCard]
           request.supportedCountries = ["US","EG"]
           request.merchantCapabilities = .threeDSecure
    
           request.countryCode = "EG"
           request.currencyCode = "EGP"
    
           request.paymentSummaryItems = [PKPaymentSummaryItem(label: "MacBook Pro M2", amount: 60000)]
    
           return request
       }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpPaymentButton()
        setUpCollectionView()
        
    }
    fileprivate func setUpPaymentButton() {
        paymentMethodButton.clipsToBounds = true
        paymentMethodButton.layer.cornerRadius = 15
        paymentMethodButton.layer.borderColor = UIColor.systemBlue.cgColor
        paymentMethodButton.layer.borderWidth = 1
    }
    
    func setUpCollectionView(){
        orderItemsCollectionView.delegate = self
        orderItemsCollectionView.dataSource = self
        
        orderItemsCollectionView.register(OrderSummaryCollectionViewCell.nib(), forCellWithReuseIdentifier: OrderSummaryCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        orderItemsCollectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        guard let paymentMethod = paymentMethod else{
            return
        }
        if paymentMethod == .cash{
            viewModel.postOrder(order: order)
        }
        else if paymentMethod == .applePay{
            payUsingApplePay()
            viewModel.postOrder(order: order)
        }
    }
    
    func payUsingApplePay(){
        guard let pkController = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest) else{return}
        
        pkController.delegate = self
        
        present(pkController, animated: true) {
            print("completed")
        }    }
    
}

extension NewOrderSummaryTableViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if order?.lineItems.count == 0{
            orderItemsCollectionView.setEmptyMessage("No Items!!")
        }
        return order?.lineItems.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = orderItemsCollectionView.dequeueReusableCell(withReuseIdentifier: OrderSummaryCollectionViewCell.id, for: indexPath) as! OrderSummaryCollectionViewCell
        
        cell.cellTitle.text = order?.lineItems[indexPath.row].title
        if order?.lineItems[indexPath.row].properties?.count ?? -1 > 0{
            cell.cellImage.kf.setImage(with: URL(string: order?.lineItems[indexPath.row].properties?[indexPath.row].name ?? ""))
        }
        cell.cellPrice.text = "\(order?.lineItems[indexPath.row].price ?? "") \(order?.currency ?? "")"
        cell.cellQuantity.text = " \(order?.lineItems[indexPath.row].quantity ?? 0)"
        return cell
        
    }
    
}

extension NewOrderSummaryTableViewController : PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {

        controller.dismiss(animated: true, completion: nil)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        completion(PKPaymentAuthorizationResult(status:.success, errors: nil))
    }
}
