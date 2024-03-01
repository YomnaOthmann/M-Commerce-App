//
//  SettingsViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit
import PassKit

class SettingsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
   
    var addressViewModel:AddressViewModel = AddressViewModel()

    @IBOutlet weak var addressSettingsTableView: UITableView!
    @IBOutlet weak var logoutView: UIView!
    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.6
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressSettingsTableView.delegate=self
        addressSettingsTableView.dataSource=self
        addressSettingsTableView.separatorStyle = .none
        addCheckButtonToView()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addressViewModel.dataObserver = {[weak self] in
            self?.addressSettingsTableView.reloadData()
        }
        addressViewModel.fetchData()
        
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
    
    
    @IBAction func seeAllAddresses(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "addressesVC") as! AddressesViewController
                
        viewController.addressViewModel = self.addressViewModel        
        self.present(viewController, animated: true, completion: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddressSettings", for: indexPath) as! AddressSettingCustomCell
        
        
        addressViewModel.setCurrentAddressAtIndex(index: indexPath.row)
        cell.customerAddress.text = addressViewModel.getAddress()
        cell.customerPhone.text = addressViewModel.getAddressPhone()

        cell.editAddressButton.cellIndex = indexPath.row
        cell.editAddressButton.addTarget(self, action:#selector(navigateToEditAddress), for: .touchUpInside)
        
        if(!addressViewModel.getDefaultValue()){
            
            cell.setDefaultButton.cellIndex = indexPath.row
            cell.setDefaultButton.addTarget(self, action:#selector(setDefaultAddress), for: .touchUpInside)
        }else{
            cell.setDefaultButton.configuration?.baseForegroundColor = UIColor.black
            cell.setDefaultButton.setTitle("Default", for: .normal)
        }
        
        return cell
    }
    
    @objc func navigateToEditAddress(sender:CustomCellButton){
        
        addressViewModel.setCurrentAddressAtIndex(index: sender.cellIndex!)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressViewController
                
        viewController.addressViewModel = self.addressViewModel
        viewController.isEdit = true
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @objc func setDefaultAddress(sender:CustomCellButton){
        
        print("set deafult address")
        addressViewModel.setCurrentAddressAtIndex(index: sender.cellIndex!)
        addressViewModel.setDefaultValue(defaultAddress: true)
            .edit { message, error in
            
            if error == nil{
                
                addressSettingsTableView.reloadData()
                CustomAlert.showAlertView(view: self, title: "Success", message:message)
                
            }else{
                
                CustomAlert.showAlertView(view: self, title: "Failed", message:message)
                
            }
        }
       
        
    }
    
}
