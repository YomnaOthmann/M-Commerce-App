//
//  AddressViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class AddressViewController: UIViewController {
    
    var addressViewModel:AddressViewModel?
    var isEdit:Bool = false
    
    @IBOutlet weak var screenTitle: UILabel!
    
    var cityItemView:CustomAddressItemView!
    var provinceItemView:CustomAddressItemView!
    var addressItemView:CustomAddressItemView!
    var phoneItemView:CustomAddressItemView!
    var postalCodeItemView:CustomAddressItemView!
    var saveCustomButton:AddressCustomButton!

    private let screenWidth = UIScreen.main.bounds.width
    private var padding:CGFloat{
        return screenWidth * 0.05
    }
    private var viewWidth:CGFloat{
        return screenWidth * 0.9
    }
    
    @IBOutlet weak var itemsScrollView: UIScrollView!
    @IBOutlet weak var addressStackView:UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit{
            screenTitle.text = "Edit Address"
        }else{
            screenTitle.text = "Add Address"
        }
        addAddressItemsToStackView()
    }
    
    
    func addAddressItemsToStackView(){
        
        let frame = CGRect(x: padding , y: 0, width: viewWidth, height: 120)
        
        cityItemView = CustomAddressItemView(frame: frame) .setAddressTextFieldTitle(title: "City")
        
        provinceItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Province")
        
        addressItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Address")
        
        phoneItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Phone")
        
        postalCodeItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Postal code")
        
        if isEdit {
            
            cityItemView            .setAddressTextFieldValue(text:addressViewModel!.getAddressCity())

            provinceItemView.setAddressTextFieldValue(text: addressViewModel!.getAddressProvince())

            addressItemView
                .setAddressTextFieldValue(text: addressViewModel!.getAddress())

            phoneItemView            .setAddressTextFieldValue(text:addressViewModel!.getAddressPhone())

            postalCodeItemView.setAddressTextFieldValue(text:addressViewModel!.getAddressPostalCode())
            
        }else{
            
            cityItemView.setAddressTextFieldPlaceHolder(placeHolder: "6-october city")
            provinceItemView.setAddressTextFieldPlaceHolder(placeHolder: "Giza")
            addressItemView.setAddressTextFieldPlaceHolder(placeHolder:"ITI 6- October city , Giza")
            phoneItemView.setAddressTextFieldPlaceHolder(placeHolder: "01234567891")
            postalCodeItemView.setAddressTextFieldPlaceHolder(placeHolder: "12345")
        }
    
        addressStackView.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
        
        addressStackView.isLayoutMarginsRelativeArrangement = true
        
        saveCustomButton = AddressCustomButton(frame:frame)
            .setupConstraints()
            .setTitleForButton(title: "Save")
        
        saveCustomButton.addTarget(self, action:#selector(saveAddress), for: .touchUpInside)
        
        addressStackView.addArrangedSubview(cityItemView)
        addressStackView.addArrangedSubview(provinceItemView)
        addressStackView.addArrangedSubview(addressItemView)
        addressStackView.addArrangedSubview(phoneItemView)
        addressStackView.addArrangedSubview(postalCodeItemView)
        //addressStackView.addArrangedSubview(CustomSpacerView(frame: frame))
        addressStackView.addArrangedSubview(saveCustomButton)
        
    }
    
    @objc func saveAddress(){
            
        let  city = cityItemView.getAddressTextFieldValue()
        let  province = provinceItemView.getAddressTextFieldValue()
        let  address = addressItemView.getAddressTextFieldValue()
        let  phone = phoneItemView.getAddressTextFieldValue()
        let  postalCode = postalCodeItemView.getAddressTextFieldValue()
        
        if self.validatAddressTextFieldValue(){
            
            let doneSetValues:AddressViewModel = addressViewModel!.setAddressCity(city: city)
                   .setAddressProvince(province: province)
                   .setAddress(address: address)
                   .setAddressPhone(phone: phone)
                   .setAddressPostalCode(postalCode:postalCode)
            
            if isEdit{
                
                doneSetValues.edit { message, error in
                    
                    if error == nil{
                        
                        CustomAlert.showAlertView(view: self, title: "Success", message:message)
                    }else{
                        
                        CustomAlert.showAlertView(view: self, title: "Failed", message:message)
                    }
                }
                                
            }else{
                
                doneSetValues.save { message, error in
                    
                    if error == nil{
                        
                        CustomAlert.showAlertView(view: self, title: "Success", message:message)
                    }else{
                        
                        CustomAlert.showAlertView(view: self, title: "Failed", message:message)
                    }
                }

            }
           }
        }
    
    func validatAddressTextFieldValue()->Bool{
        
        if cityItemView.getAddressTextFieldValue().isEmpty {
         
            CustomAlert.showAlertView(view: self, title: "validator", message:"city field can't be empty ")
            
            return false
            
        }else if provinceItemView.getAddressTextFieldValue().isEmpty {
            
            CustomAlert.showAlertView(view: self, title: "validator", message:"province field can't be empty ")
            
            return false

        }else if addressItemView.getAddressTextFieldValue().isEmpty {
            
            CustomAlert.showAlertView(view: self, title: "validator", message:"address field can't be empty ")
            
            return false

        } else if phoneItemView.getAddressTextFieldValue().isEmpty {
            
            CustomAlert.showAlertView(view: self, title: "validator", message:"phone field can't be empty ")
            
            return false

        }
        else if postalCodeItemView.getAddressTextFieldValue() .isEmpty{
            
            CustomAlert.showAlertView(view: self, title: "validator", message:"postalCode field can't be empty ")
            
            return false

        }else{
            
            return true
        }
        
    }
    
    @IBAction func backToPrevious(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
