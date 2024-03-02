//
//  OrdersScreenViewController.swift
//  Shopify
//
//  Created by Mac on 27/02/2024.
//

import UIKit

class OrdersScreenViewController: UIViewController {

    @IBOutlet weak var ordersTable: UITableView!
    var indicator = UIActivityIndicatorView(style: .medium)
    let viewModel = OrdersScreenViewModel(network: NetworkManager())
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?
    var orders : [Order]?
    override func viewDidLoad() {
        super.viewDidLoad()

        ordersTable.delegate = self
        ordersTable.dataSource = self
        
        ordersTable.register(OrdersTableViewCell.nib(), forCellReuseIdentifier: OrdersTableViewCell.id)
        setIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
            viewModel.fetchOrders()
        viewModel.bindOrders = {
            self.orders = self.viewModel.orders
            self.ordersTable.reloadData()
            self.indicator.stopAnimating()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    func setIndicator(){
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
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
                viewModel.fetchOrders()
                ordersTable.reloadData()
            }
            
        }else{
            if !alertIsPresenting{
                connectionAlert.showAlert(view: self)
                alertIsPresenting = true
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
}

extension OrdersScreenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.id, for: indexPath) as! OrdersTableViewCell
        
        cell.orderNumber.text = "\(orders?[indexPath.row].orderNumber ?? 0)"
        cell.orderPrice.text  =  "\(orders?[indexPath.row].currentTotalPrice ?? "") \(orders?[indexPath.row].currency ?? "")"
        cell.orderItemsQuantity.text =  "\(orders?[indexPath.row].lineItems.count ?? 0)"
        cell.orderFinancialState.text = orders?[indexPath.row].financialStatus.rawValue
        cell.orderDate.text = orders?[indexPath.row].createdAt?.components(separatedBy: "T").first
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderSummaryVC = self.storyboard?.instantiateViewController(identifier: "orderDetail") as! OrderSummaryScreenViewController
        orderSummaryVC.order = orders?[indexPath.row]
     
        self.navigationController?.pushViewController(orderSummaryVC, animated: true)
    }
    
}
