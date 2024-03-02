//
//  CustomAddressItemView.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 25/02/2024.
//

import UIKit

class CustomAddressItemView: UIView {

    private var addressTextFieldTitle:UILabel?
    private var addressTextField:UITextField?
        
    private let screenWidth = UIScreen.main.bounds.width
    
    private var viewWidth:CGFloat{
        return screenWidth * 0.9
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
                
        addSubview(self.getLabelView())
        addSubview(self.getTextField())
        
        heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        widthAnchor.constraint(equalToConstant:(viewWidth)).isActive = true
        
       // addressViewItem.backgroundColor = .black
        
    }
    
    private func getLabelView()-> UILabel{
        
        let fieldName = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        fieldName.textColor = .black
        fieldName.font =  UIFont(name: "Montserrat", size: 18)
        
        self.addressTextFieldTitle = fieldName
        return self.addressTextFieldTitle ?? fieldName
    }
    
    private func getTextField() -> UITextField {
        
        let textField = UITextField(frame: CGRect(x: 0, y: 40, width:viewWidth, height: 60))
        
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 60))
        textField.leftViewMode = .always
        self.addressTextField = textField
        
        return self.addressTextField ?? textField
    }
    
    func setAddressTextFieldTitle(title:String)-> CustomAddressItemView{
        
        self.addressTextFieldTitle?.text = title
        return self
    }
    
    func setAddressTextFieldValue(text:String) {
        self.addressTextField?.text = text
    }
    
    func setAddressTextFieldPlaceHolder(placeHolder:String) {
        
        self.addressTextField?.placeholder = placeHolder
    }
    
    func getAddressTextFieldValue()-> String{
        return self.addressTextField?.text ?? ""
    }
}
