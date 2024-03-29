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
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var applyDiscardCoupon: UIButton!
    
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var continueButtonView: UIView!
    
    var checkoutViewModel:CheckoutViewModel?
    var addressViewModel:AddressViewModel?
    var shoppingBagViewModel:ShoppingBagViewModel?
    
    private var selectedPaymentMethod:PaymentMethodSelector = .none
    private var addressSelected =  false
    var applyCoupon:Bool = false
    
    
//    private var paymentRequest:PKPaymentRequest = {
//       
//       let request = PKPaymentRequest()
//       request.merchantIdentifier = "merchant.com.faisaltag.pay"
//       request.supportedNetworks = [.visa,.masterCard]
//       request.supportedCountries = ["US","EG"]
//       request.merchantCapabilities = .threeDSecure
//       
//       request.countryCode = "EG"
//       request.currencyCode = "EGP"
//       
//       request.paymentSummaryItems = [PKPaymentSummaryItem(label: "MacBook Pro M2", amount: 60000)]
//       
//       return request
//   }()

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
        
        if(applyCoupon){
            discount.text = checkoutViewModel?.getDiscount()
            orderTotalPrice.text = checkoutViewModel?.getOrderTotalPrice()
        }else{
            discount.text = "0"
            orderTotalPrice.text = checkoutViewModel?.getlineItemsTotalPrice()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("addressViewModel?.isDefaultAddressCashed()")
        print(addressViewModel?.isDefaultAddressCashed())
        
        
        if addressViewModel?.isDefaultAddressCashed() ?? false {
            
            addressSelected = true
            addressViewModel?.setDeafultAddress()
            defaultAddress.text = addressViewModel?.getAddress()
            contact.text = addressViewModel?.getAddressPhone()
            
        }else{
            
            self.addressSelected = false
            self.setupAddDefaultAddressButton()

        }
        
        addressViewModel?.dataObserver = {
            
           if self.addressViewModel?.isDefaultAddressCashed() ?? false {
               
                self.addressSelected = true
                self.addressViewModel?.setDeafultAddress()
                self.defaultAddress.text = self.addressViewModel?.getAddress()
                self.contact.text = self.addressViewModel?.getAddressPhone()
                
            }else{
                
                self.addressSelected = false
                self.setupAddDefaultAddressButton()
            }
        }

        addressViewModel?.fetchData()

    }
    
    func addContinueButtonToView(){
        
        let frame = CGRect(x:0, y: 0, width: viewWidth, height: 50)
        let continueButton = CheckoutCustomButton(frame: frame).setTitleForButton(title: "Continue")

        continueButton.addTarget(self, action: #selector(navigateToOrderSummary), for: .touchUpInside)
        continueButtonView.addSubview(continueButton)
        
    }
    

    func setupAddDefaultAddressButton(){
      
        let frame = CGRect(x:0, y: 0, width: viewWidth, height: 50)
        let addDefaultAddressButton = CheckoutCustomButton(frame: frame).setTitleForButton(title: "Add Default Address")
        
        addressBackground.isHidden = true
        addressParentView.addSubview(addDefaultAddressButton)

        addDefaultAddressButton.center = CGPointMake(addressParentView.frame.size.width  / 2,
                                                     addressParentView.frame.size.height / 2);

        addDefaultAddressButton.addTarget(self, action: #selector(navigateToAddDefaultAddress), for: .touchUpInside)

    }
  
    @objc func navigateToOrderSummary(){
        
        guard NetworkReachability.networkReachability.networkStatus == true else{
            
            let settings = UIStoryboard(name: "Settings", bundle: nil)
            
            let checkConnectVC = settings.instantiateViewController(withIdentifier: "checkConnectVC") as! CheckConnectionScreen
            
            checkConnectVC.modalPresentationStyle = .fullScreen
            self.present(checkConnectVC, animated: true)
            
            return
        }
        
        if selectedPaymentMethod == .none {
            
            CustomAlert.showAlertView(view: self, title: "Payment Method", message: "Please select Payment Method to continue")
            
        }else if addressSelected == false{
            
            CustomAlert.showAlertView(view: self, title: "Default Address", message: "Please select Default Address to continue")
        }else{
            
            let orderBuilder = checkoutViewModel?.getOrderBuilder()
            
            if applyCoupon == false {
                
                orderBuilder?.setCurrentTotalDiscounts(currentTotalDiscounts: "0")
                
                orderBuilder?.setCurrentTotalPrice(currentTotalPrice: checkoutViewModel!.getlineItemsTotalPriceWithoutCurrency())
            }
            
            orderBuilder?.setShippingAddress(shippingAddress: addressViewModel!.getOrderAddress())
            
            orderBuilder?.setCustomerID(id: addressViewModel!.getCustomerID())
            
            let orderSummaryVC = UIStoryboard(name: "PlacingOrder", bundle: nil).instantiateViewController(withIdentifier: "placeOrder")
            as! NewOrderSummaryTableViewController
            
            orderSummaryVC.order = orderBuilder?.build()
            
            print(orderSummaryVC.order!)
            
            orderSummaryVC.paymentMethod = selectedPaymentMethod
            orderSummaryVC.modalPresentationStyle = .fullScreen
            self.present(orderSummaryVC, animated: true)
            
        }
        
    }
    
    
    @objc func navigateToAddDefaultAddress(){
        
        guard NetworkReachability.networkReachability.networkStatus == true else{
            
            let settings = UIStoryboard(name: "Settings", bundle: nil)
            
            let checkConnectVC = settings.instantiateViewController(withIdentifier: "checkConnectVC") as! CheckConnectionScreen
            
            checkConnectVC.modalPresentationStyle = .fullScreen
            self.present(checkConnectVC, animated: true)
            
            return
        }

        
        let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "addressesVC") as! AddressesViewController
        
        viewController.addressViewModel = self.addressViewModel
        self.present(viewController, animated: true, completion: nil)
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
        
        guard NetworkReachability.networkReachability.networkStatus == true else{
            
            let settings = UIStoryboard(name: "Settings", bundle: nil)
            
            let checkConnectVC = settings.instantiateViewController(withIdentifier: "checkConnectVC") as! CheckConnectionScreen
            
            checkConnectVC.modalPresentationStyle = .fullScreen
            self.present(checkConnectVC, animated: true)
            
            return
        }

        
        let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(identifier: "addressesVC") as! AddressesViewController
        
        viewController.addressViewModel = self.addressViewModel
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func selectApplePay(_ sender: Any) {
        
        if(selectedPaymentMethod == .none || selectedPaymentMethod == .cash ){
            
            cashBackground.layer.borderWidth = 0
            selectedPaymentMethod = .applePay
            
            applePayBackGround.layer.borderWidth = 2
            applePayBackGround.layer.borderColor = UIColor.customBlue.cgColor

//            guard let pkController = PKPaymentAuthorizationViewController(paymentRequest: self.paymentRequest) else{return}
//            
//            pkController.delegate = self
//            
//            present(pkController, animated: true) {
//                print("completed")
//            }
            
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
    
    
    @IBAction func ApplyDiscardDiscount(_ sender: Any) {
        
        applyCoupon = !applyCoupon
        
        if(applyCoupon){
            discount.text = checkoutViewModel?.getDiscount()
            orderTotalPrice.text = checkoutViewModel?.getOrderTotalPrice()
            applyDiscardCoupon.setTitle("Discard", for: .normal)
        }else{
            discount.text = "0"
            orderTotalPrice.text = checkoutViewModel?.getlineItemsTotalPrice()
            applyDiscardCoupon.setTitle("Apply Coupon", for: .normal)
        }
        
    }
    
    @IBAction func backToPreviousViewController(_ sender: Any) {
        
        guard NetworkReachability.networkReachability.networkStatus == true else{
            
            let settings = UIStoryboard(name: "Settings", bundle: nil)
            
            let checkConnectVC = settings.instantiateViewController(withIdentifier: "checkConnectVC") as! CheckConnectionScreen
            
            checkConnectVC.modalPresentationStyle = .fullScreen
            self.present(checkConnectVC, animated: true)
            
            return
        }

        
        dismiss(animated: true, completion: nil)

    }
    
    
//    @IBAction func addCoupon(_ sender: Any) {
//        
//        let alert = UIAlertController(title: "Coupon Code", message: "Please enter coupon code", preferredStyle: .alert)
//
//        alert.addTextField(configurationHandler: { (textField) -> Void in
//            textField.placeholder = "ex: NEWRIDER50"
//        })
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
//            let textField = (alert?.textFields![0] ?? UITextField()) as UITextField
//            
//            
//            if textField.text == nil || textField.text == "" {
//                
//                CustomAlert.showAlertView(view: self, title: "validator", message: "please enter your code , field can't be empty")
//                
//            }else{
//                self.couponCode = textField.text
//            }
//            
//            print(self.couponCode ?? "nil")
//        }))
//         self.present(alert, animated: true)
//    }
    
}



//extension CheckoutViewController : PKPaymentAuthorizationViewControllerDelegate {
//    
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        
//        completion(PKPaymentAuthorizationResult(status:.success, errors: nil))
//    }
//}
