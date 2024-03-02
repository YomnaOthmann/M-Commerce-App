//
//  CheckoutViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 26/02/2024.
//

import UIKit
import PassKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var addressParentView: UIView!
    @IBOutlet weak var addressBackground: UIView!
    @IBOutlet weak var defaultAddress: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    
    @IBOutlet weak var applePayParentView: UIView!
    @IBOutlet weak var applePayBackGround: UIView!
    
    @IBOutlet weak var cashParentView: UIView!
    @IBOutlet weak var cashBackground: UIView!
    
    
    @IBOutlet weak var productsTotalPrice: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    
    @IBOutlet weak var continueButtonView: UIView!
    
    var checkoutViewModel:CheckoutViewModel?
    private var selectedPaymentMethod:PaymentMethodSelector = .none
    var couponCode:String?
    
    private var paymentRequest:PKPaymentRequest = {
       
       let request = PKPaymentRequest()
       request.merchantIdentifier = "merchant.com.faisaltag.pay"
       request.supportedNetworks = [.visa,.masterCard]
       request.supportedCountries = ["US","EG"]
       request.merchantCapabilities = .threeDSecure
       
       
       request.countryCode = "EG"
       request.currencyCode = "EGP"
       
       request.paymentSummaryItems = [PKPaymentSummaryItem(label: "MacBook Pro M2", amount: 60000)]
       
       return request
   }()

    private let screenWidth = UIScreen.main.bounds.width

    private var viewWidth:CGFloat{
        return screenWidth * 0.7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAddressView()
        setupApplePayView()
        setupCashOnDeliveryView()
        addContinueButtonToView()
        
        productsTotalPrice.text = checkoutViewModel?.getlineItemsTotalPrice()
        deliveryFee.text = checkoutViewModel?.getLineDeliveryFee()
        orderTotalPrice.text = checkoutViewModel?.getOrderTotalPrice()
        
    }
    
    func addContinueButtonToView(){
        
        let frame = CGRect(x:0, y: 0, width: viewWidth, height: 50)
        
        let continueButton = CheckoutCustomButton(frame: frame).setTitleForButton(title: "Continue")
        continueButton.addTarget(self, action: #selector(navigateToOrderSummary), for: .touchUpInside)
        
        continueButtonView.addSubview(continueButton)
    }
    
    @objc func navigateToOrderSummary(){
        let orderSummaryVC = UIStoryboard(name: "PlacingOrder", bundle: nil).instantiateViewController(withIdentifier: "placeOrder")
        
        self.present(orderSummaryVC, animated: true)
    }
    
    func setupAddressView(){
        
        
        addressBackground.layer.cornerRadius = 8
        addressBackground.backgroundColor = .white
        
        addressParentView.layer.shadowColor = UIColor.black.cgColor
        addressParentView.layer.shadowOpacity = 0.4
        addressParentView.layer.shadowOffset = CGSize.zero
        addressParentView.layer.shadowRadius = 3
    }
    func setupApplePayView(){
        
        applePayBackGround.layer.cornerRadius = 8
        applePayBackGround.backgroundColor = .white
        
        applePayParentView.layer.shadowColor = UIColor.black.cgColor
        applePayParentView.layer.shadowOpacity = 0.4
        applePayParentView.layer.shadowOffset = CGSize.zero
        applePayParentView.layer.shadowRadius = 3
        
    }
    
    func setupCashOnDeliveryView(){
        
        cashBackground.layer.cornerRadius = 8
        cashBackground.backgroundColor = .white
        
        cashParentView.layer.shadowColor = UIColor.black.cgColor
        cashParentView.layer.shadowOpacity = 0.4
        cashParentView.layer.shadowOffset = CGSize.zero
        cashParentView.layer.shadowRadius = 3
    }
    
    @IBAction func changeAddress(_ sender: Any) {
        
        
        let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "addressesVC") as! AddressesViewController
        
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func selectApplePay(_ sender: Any) {
        
        if(selectedPaymentMethod == .none || selectedPaymentMethod == .cash ){
            
            cashBackground.layer.borderWidth = 0
            selectedPaymentMethod = .applePay
            
            applePayBackGround.layer.borderWidth = 2
            applePayBackGround.layer.borderColor = UIColor.customBlue.cgColor

            guard let pkController = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest) else{return}
            
            pkController.delegate = self
            
            present(pkController, animated: true) {
                print("completed")
            }
            
        }else{return}
    }
    
    
    
    @IBAction func selectCashOnDelivery(_ sender: Any) {
        
        if(selectedPaymentMethod == .none || selectedPaymentMethod == .applePay ){
            
            applePayBackGround.layer.borderWidth = 0
            selectedPaymentMethod = .cash
            
            cashBackground.layer.borderWidth = 2
            cashBackground.layer.borderColor = UIColor.customBlue.cgColor
            
        }else{return}
        
    }
    
    @IBAction func backToPreviousViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func addCoupon(_ sender: Any) {
        
        let alert = UIAlertController(title: "Coupon Code", message: "Please enter coupon code", preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "ex: NEWRIDER50"
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0] ?? UITextField()) as UITextField
            
            
            if textField.text == nil || textField.text == "" {
                
                CustomAlert.showAlertView(view: self, title: "validator", message: "please enter your code , field can't be empty")
                
            }else{
                self.couponCode = textField.text
            }
            
            print(self.couponCode ?? "nil")

            
        }))
        
         self.present(alert, animated: true)
    }
    
}



enum PaymentMethodSelector : String {
    case none = "none"
    case applePay = "applePay"
    case cash = "cash"
}

extension CheckoutViewController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(PKPaymentAuthorizationResult(status:.success, errors: nil))
    }
}
