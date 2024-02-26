//
//  AddressViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class AddressViewController: UIViewController {
    
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
        
        addAddressItemsToStackView()
    }
    
    
    func addAddressItemsToStackView(){
        
        let frame = CGRect(x: padding , y: 0, width: viewWidth, height: 120)
        
        cityItemView = CustomAddressItemView(frame: frame) .setAddressTextFieldTitle(title: "City")
            .setAddressTextFieldPlaceHolder(palceHolder: "6-october city")

        provinceItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Province")
            .setAddressTextFieldPlaceHolder(palceHolder: "Giza")
        
        addressItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Address")
            .setAddressTextFieldPlaceHolder(palceHolder: "iti,smart village, 6-october city , Giza")
        
        phoneItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Phone")
            .setAddressTextFieldPlaceHolder(palceHolder: "01223334444")
        
        postalCodeItemView = CustomAddressItemView(frame: frame)
            .setAddressTextFieldTitle(title: "Postal code")
            .setAddressTextFieldPlaceHolder(palceHolder: "12911")
        
        addressStackView.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
        addressStackView.isLayoutMarginsRelativeArrangement = true
        
        saveCustomButton = AddressCustomButton(frame:frame)
            .setupConstraints()
            .setTitleForButton(title: "Save")
        
        addressStackView.addArrangedSubview(cityItemView)
        addressStackView.addArrangedSubview(provinceItemView)
        addressStackView.addArrangedSubview(addressItemView)
        addressStackView.addArrangedSubview(phoneItemView)
        addressStackView.addArrangedSubview(postalCodeItemView)
        //addressStackView.addArrangedSubview(CustomSpacerView(frame: frame))
        addressStackView.addArrangedSubview(saveCustomButton)
        
    }
    
}
