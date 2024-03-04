//
//  AddressesViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 24/02/2024.
//

import UIKit

class AddressesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var addressesTableView: UITableView!
    var addressViewModel:AddressViewModel?
    var isFromSettings:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addressViewModel?.dataObserver = {[weak self] in
            
            self?.addressesTableView.reloadData()
            print("addressesTableView.reloadData()")
            print("AddressesViewController")
        }
        
             addressViewModel?.fetchData()
 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressViewModel!.getAddressesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddress", for: indexPath) as! AddressesTableViewCell
        
        addressViewModel?.setCurrentAddressAtIndex(index: indexPath.row)
        cell.customerAddress.text = addressViewModel?.getAddress()
        cell.customerPhone.text = addressViewModel?.getAddressPhone()

        cell.editAddressButton.cellIndex = indexPath.row
        cell.editAddressButton.addTarget(self, action:#selector(navigateToEditAddress), for: .touchUpInside)
        
        print("addressViewModel.getDefaultValue() index :\(indexPath.row) ")
        print(addressViewModel!.getDefaultValue())

        if(!addressViewModel!.getDefaultValue()){
            
            cell.setDefaultButton.isEnabled = true
            cell.setDefaultButton.setTitle("Set Default",for: .normal)
            cell.setDefaultButton.configuration?.baseForegroundColor = UIColor.customBlue
            cell.setDefaultButton.cellIndex = indexPath.row
            cell.setDefaultButton.addTarget(self, action:#selector(setDefaultAddress), for: .touchUpInside)
            
        }else{
            
            cell.setDefaultButton.configuration?.baseForegroundColor = UIColor.black
            cell.setDefaultButton.setTitle("Default", for: .normal)
            cell.setDefaultButton.isEnabled = false
            

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            addressViewModel?.setCurrentAddressAtIndex(index: indexPath.row)
            addressViewModel?.deleteAddress(completion: { message, error in
                
                if error == nil {
                    
                    CustomAlert.showAlertView(view: self, title: "Delete Successfully", message: message)

                }else{
                    
                    CustomAlert.showAlertView(view: self, title: "Delete Failed", message: message)

                }
            })
        }
    }
    
    @objc func navigateToEditAddress(sender:CustomCellButton){
        
        addressViewModel?.setCurrentAddressAtIndex(index: sender.cellIndex!)
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressViewController
                
        viewController.addressViewModel = self.addressViewModel
        viewController.isEdit = true
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func setDefaultAddress(sender:CustomCellButton){
        
        
        if addressViewModel?.isDefaultAddressCashed() ?? false {
            
            changeCurrentDefaultAddressValue(sender:sender)
            
        }else{
            
            setNewAddressAsDefault(index:sender.getIndex())
        }
    }
    
    func changeCurrentDefaultAddressValue(sender:CustomCellButton){
        
        addressViewModel?.setDeafultAddress()
        addressViewModel?.setDefaultValue(defaultAddress:false)
        
            .edit(isEditNotSetDefault:false){ message, error in
                
            if error == nil {
                self.setNewAddressAsDefault(index: sender.getIndex())
            }else{
                CustomAlert.showAlertView(view: self, title: "Failed", message:message)
            }
        }

    }
    
    func setNewAddressAsDefault(index:Int){
        addressViewModel?.setCurrentAddressAtIndex(index: index)
        addressViewModel?.setDefaultValue(defaultAddress: true)
        .edit(isEditNotSetDefault:false){ message, error in
            
            if error == nil{
                
                self.addressesTableView.reloadData()
                CustomAlert.showAlertView(view: self, title: "Success", message:message)
                
            }else{
                CustomAlert.showAlertView(view: self, title: "Failed", message:message)
            }
        }
    }
    
    
    @IBAction func addNewAddress(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressViewController
                
        viewController.addressViewModel = self.addressViewModel
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func backToPrevious(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
