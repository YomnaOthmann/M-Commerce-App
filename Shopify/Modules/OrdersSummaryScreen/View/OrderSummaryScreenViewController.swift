//
//  OrderSummaryScreenViewController.swift
//  Shopify
//
//  Created by Mac on 28/02/2024.
//

import UIKit
import Kingfisher
class OrderSummaryScreenViewController: UIViewController {
    
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderTax: UILabel!
    @IBOutlet weak var orderDiscountPrice: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var draftOrderCollectionView: UICollectionView!
    
    let viewModel = OrderSummaryScreenViewModel(network: NetworkManager())
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?
    
    var order:Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpOrderData()
    }
    func setUpCollectionView(){
        
        draftOrderCollectionView.delegate = self
        draftOrderCollectionView.dataSource = self
        draftOrderCollectionView.register(OrderSummaryCollectionViewCell.nib(), forCellWithReuseIdentifier: OrderSummaryCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        draftOrderCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }

    func setUpOrderData(){
        orderPrice.text = (order?.subtotalPrice ?? "") +  " " + (order?.currency ?? "")
        if order?.lineItems[0].taxLines?.count ?? -1 > 0{
            orderTax.text = ((order?.lineItems[0].taxLines?[0].price ?? "") + " " + (order?.currency ?? ""))
        }else{
            orderTax.text = "0.0" + (order?.currency ?? "")
        }
        
        orderDiscountPrice.text = (order?.currentTotalDiscounts ?? "") + " " + (order?.currency ?? "")
        orderTotalPrice.text =
        ((order?.currentTotalPrice ?? "") + " " + (order?.currency ?? ""))
        
        guard let address = order?.shippingAddress else{
            orderAddress.text = "No Address Provided"
            return
        }
        
        orderAddress.text = "\(address.address1 ?? "")\(address.city ?? "")\(address.country ?? "") \nContact: \(address.phone ?? "") "
        
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkReachability), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    @objc func checkReachability(){
        if viewModel.checkReachability(){
            if alertIsPresenting{
                connectionAlert.dismissAlert()
                alertIsPresenting = false
            }
            
        }else{
            if !alertIsPresenting{
                connectionAlert.showAlert(view: self)
                alertIsPresenting = true
            }

        }
    }


    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension OrderSummaryScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: draftOrderCollectionView.frame.width * 0.4, height: draftOrderCollectionView.frame.height - 10)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        order?.lineItems.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = draftOrderCollectionView.dequeueReusableCell(withReuseIdentifier: OrderSummaryCollectionViewCell.id, for: indexPath) as! OrderSummaryCollectionViewCell
        
        cell.cellTitle.text = order?.lineItems[indexPath.row].title
        if order?.lineItems[indexPath.row].properties?.count ?? -1 > 0{
            cell.cellImage.kf.setImage(with: URL(string: order?.lineItems[indexPath.row].properties![indexPath.row].name ?? ""))
        }
        cell.cellPrice.text = "\(order?.lineItems[indexPath.row].price ?? "") \(order?.currency ?? "")"
        cell.cellQuantity.text = " \(order?.lineItems[indexPath.row].quantity ?? 0)"
        return cell
        
    }
}
