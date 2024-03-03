//
//  MeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class MeScreenViewController: UITableViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userMail: UILabel!
    
    
    @IBOutlet weak var firstOrderNumber: UILabel!
    @IBOutlet weak var firstOrderPrice: UILabel!
    @IBOutlet weak var firstOrderQuantity: UILabel!
    @IBOutlet weak var firstOrderStatus: UILabel!
    @IBOutlet weak var firstOrderDate: UILabel!
    @IBOutlet weak var firstOrderStack: UIStackView!
    
    @IBOutlet weak var secondOrderNumber: UILabel!
    @IBOutlet weak var secondOrderPrice: UILabel!
    @IBOutlet weak var secondOrderQuantity: UILabel!
    @IBOutlet weak var secondOrderStatus: UILabel!
    @IBOutlet weak var secondOrderStack: UIStackView!
    @IBOutlet weak var secondOrderDate: UILabel!
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    var orders : [Order]?
    let indicator = UIActivityIndicatorView(style: .medium)
    let viewModel = MeScreenViewModel(network: NetworkManager())
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?
    
    var user:Customer?
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.layer.cornerRadius = 20
        userName.text = "Yomna Othman"
        userMail.text = "yomnaothmann@gmail.com"
        self.firstOrderStack.isHidden = true
        self.secondOrderStack.isHidden = true
        setUpCollectionView()
        setUpIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
        viewModel.fetchOrders()
        viewModel.bindOrders = {
            self.orders = self.viewModel.orders
            self.setUpOrdersItems()
            self.firstOrderStack.isHidden = false
            self.secondOrderStack.isHidden = false
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    func setUpIndicator(){
        indicator.center = view.center
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkReachability), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    @objc func checkReachability(){
        if viewModel.checkReachability(){
            if alertIsPresenting{
                connectionAlert.dismissAlert()
                alertIsPresenting = false
                viewModel.fetchOrders()
                self.tableView.reloadData()
            }
            
        }else{
            if !alertIsPresenting{
                connectionAlert.showAlert(view: self)
                alertIsPresenting = true
            }
        }
    }
    func setUpCollectionView(){
        
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        favCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    func setUpOrdersItems(){
        secondOrderNumber.text = "\(orders?[0].orderNumber ?? 0)"
        secondOrderPrice.text  =  "\(orders?[0].currentTotalPrice ?? "") \(orders?[0].currency ?? "")"
        secondOrderQuantity.text =  "\(orders?[0].lineItems.count ?? 0)"
        secondOrderStatus.text = orders?[0].financialStatus.rawValue
        secondOrderDate.text = orders?[0].createdAt?.components(separatedBy: "T").first
        
        
        firstOrderNumber.text = "\(orders?[1].orderNumber ?? 0)"
        firstOrderPrice.text  =  "\(orders?[1].currentTotalPrice ?? "") \(orders?[1].currency ?? "")"
        firstOrderQuantity.text =  "\(orders?[1].lineItems.count ?? 0)"
        firstOrderStatus.text = orders?[1].financialStatus.rawValue
        firstOrderDate.text = orders?[1].createdAt?.components(separatedBy: "T").first
    }

    @IBAction func gotoSettings(_ sender: Any) {
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
        settingsVC.modalPresentationStyle = .fullScreen
        self.present(settingsVC, animated: true)
    }
    
    @IBAction func goToCart(_ sender: Any) {
        let cartStoryboard = UIStoryboard(name: "ShoppingBag", bundle: nil)
        let cartVC = cartStoryboard.instantiateViewController(withIdentifier: "cart")
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: true)
        
    }
}
extension MeScreenViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 2:
            let ordersStoryboard = UIStoryboard(name: "OrdersScreen", bundle: nil)
            let ordersVC = ordersStoryboard.instantiateViewController(withIdentifier: "orders")
            ordersVC.modalPresentationStyle = .fullScreen
            self.present(ordersVC, animated: true)
            
        default:
            // TODO: Navigate to wishlist Screen
            break
        }
    }
    
    
}
extension MeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: favCollectionView.frame.width * 0.4, height: favCollectionView.frame.height - 10)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favCollectionView.setEmptyMessage("Empty Wishlist!!")
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as!ProductCollectionViewCell
       
        
        return cell
    }
}

