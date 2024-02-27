//
//  SettingsViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit
import PassKit

class SettingsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var deliveryAddressSettingsTableView: UITableView!
    
    @IBOutlet weak var logoutView: UIView!
    
    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.6
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryAddressSettingsTableView.delegate=self
        deliveryAddressSettingsTableView.dataSource=self
        deliveryAddressSettingsTableView.separatorStyle = .none
        addCheckButtonToView()
    }
    
    func addCheckButtonToView(){
        
        let frame = CGRect(x:0, y: 0, width: viewWidth , height: 50)
        
        let logoutButton = LogoutCustomButton(frame: frame).setTitleForButton(title: "Logout")
        
        logoutView.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutCustomer), for: .touchUpInside)
        
        
    }
    
    @objc func logoutCustomer(){
        print("Logout")
        
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
    
    
}
