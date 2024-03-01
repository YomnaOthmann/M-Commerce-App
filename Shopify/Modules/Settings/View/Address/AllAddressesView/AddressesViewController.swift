//
//  AddressesViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 24/02/2024.
//

import UIKit

class AddressesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var addressesTableView: UITableView!
    var addressViewModel = AddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressesTableView.delegate=self
        addressesTableView.dataSource=self
        addressesTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addressViewModel.dataObserver = {[weak self] in
            self?.addressesTableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressViewModel.getAddressesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddress", for: indexPath) as! AddressesTableViewCell
        
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
        
        
        addressViewModel.setCurrentAddressAtIndex(index: sender.cellIndex!)
        addressViewModel.setDefaultValue(defaultAddress: true)
        addressViewModel.edit { message, error in
            
            if error != nil{
                
                addressesTableView.reloadData()
                CustomAlert.showAlertView(view: self, title: "Success", message:message)
                
            }else{
                
                CustomAlert.showAlertView(view: self, title: "Failed", message:message)
                
            }
        }
    }
    
    @IBAction func backToPrevious(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
