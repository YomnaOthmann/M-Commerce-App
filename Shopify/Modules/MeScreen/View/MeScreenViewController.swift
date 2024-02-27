//
//  MeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class MeScreenViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var user:Customer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        userView.layer.cornerRadius = 20
        userName.text = "Yomna Othman"
        userMail.text = "yomnaothmann@gmail.com"
    }
    
    @IBAction func goToWishlist(_ sender: Any) {
        //TODO: navigate to wishlist
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goToCart(_ sender: Any) {
        let cartStoryboard = UIStoryboard(name: "ShoppingBag", bundle: nil)
        let cartVC = cartStoryboard.instantiateViewController(withIdentifier: "") as! ShoppingBagViewController
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: true)
        
    }
}
extension MeScreenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "Orders"
        default:
            cell.textLabel?.text = "Settings"
        }
        cell.textLabel?.font = UIFont(name: "MontserratMedium", size: 18)
        cell.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let ordersStoryboard = UIStoryboard(name: "OrdersScreen", bundle: nil)
            let ordersVC = ordersStoryboard.instantiateViewController(withIdentifier: "orders") 
            ordersVC.modalPresentationStyle = .fullScreen
            self.present(ordersVC, animated: true)
            //TODO: Navigate to Orders Screen
        default:
            // TODO: Navigate to Settings Screen
            let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
            let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "")
            settingsVC.modalPresentationStyle = .fullScreen
            self.present(settingsVC, animated: true)
        }
    }
    
    
}
