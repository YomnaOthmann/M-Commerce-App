//
//  SettingsViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class SettingsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var deliveryAddressSettingsTableView: UITableView!
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentViewBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryAddressSettingsTableView.delegate=self
        deliveryAddressSettingsTableView.dataSource=self
        deliveryAddressSettingsTableView.separatorStyle = .none
        setupPaymentView()
        
    }
    
    
    @IBAction func setupPayment(_ sender: Any) {
        
    }
    
    func setupPaymentView(){
        
        paymentView.layer.cornerRadius = 8
        paymentView.backgroundColor = .white
        
        paymentViewBackground.layer.shadowColor = UIColor.black.cgColor
        paymentViewBackground.layer.shadowOpacity = 0.4
        paymentViewBackground.layer.shadowOffset = CGSize.zero
        paymentViewBackground.layer.shadowRadius = 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressSettings", for: indexPath) as! DeliveryAddressSettingCustomCell
        
        cell.customerAddress.text = " iti-6 oct city,giza"
        cell.customerPhone.text = "0998877543456"
        
        return cell
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {

      }
}

