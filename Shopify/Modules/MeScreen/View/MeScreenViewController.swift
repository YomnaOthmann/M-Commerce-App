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
    
    @IBOutlet weak var orderCell: OrdersTableViewCell!
    
    var orders : [Order]?
    let indicator = UIActivityIndicatorView(style: .medium)
    let viewModel = MeScreenViewModel(network: NetworkManager())
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?
    var wishList : DraftOrder?
    @IBOutlet weak var favIndicator: UIActivityIndicatorView!
    var user:Customer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "isLogged"){
            self.tableView.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            let notLoggedVC = UIStoryboard(name: "MeScreen", bundle: nil).instantiateViewController(withIdentifier: "notLogged")
            self.navigationController?.setViewControllers([notLoggedVC], animated: false)
        }
        user = viewModel.getUser()
        userView.layer.cornerRadius = 20
        userName.text = user?.firstName
        userMail.text = user?.email
        setUpCollectionView()
        setUpIndicator()
        firstOrderStack.isHidden = true
        secondOrderStack.isHidden = true
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
        viewModel.fetchWishlist()
        viewModel.bindResult = {
            self.wishList = self.viewModel.wishlist
            self.favCollectionView.reloadData()
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
        favIndicator.center = view.center
        favIndicator.color = .gray
        favIndicator.hidesWhenStopped = true
        favIndicator.startAnimating()
        view.addSubview(favIndicator)
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
        if orders?.count != 0{
            firstOrderNumber.text = "\(orders?[0].orderNumber ?? 0)"
            firstOrderPrice.text  =  "\(orders?[0].currentTotalPrice ?? "") \(orders?[0].currency ?? "")"
            firstOrderQuantity.text =  "\(orders?[0].lineItems.count ?? 0)"
            firstOrderStatus.text = orders?[0].financialStatus?.rawValue
            firstOrderDate.text = orders?[0].createdAt?.components(separatedBy: "T").first
            firstOrderStack.isHidden = false
            if orders?.count ?? 0 > 1{
                secondOrderNumber.text = "\(orders?[1].orderNumber ?? 0)"
                secondOrderPrice.text  =  "\(orders?[1].currentTotalPrice ?? "") \(orders?[1].currency ?? "")"
                secondOrderQuantity.text =  "\(orders?[1].lineItems.count ?? 0)"
                secondOrderStatus.text = orders?[1].financialStatus?.rawValue
                secondOrderDate.text = orders?[1].createdAt?.components(separatedBy: "T").first
                secondOrderStack.isHidden = false
            }

        }else{
            firstOrderStack.isHidden = true
            secondOrderStack.isHidden = true
        }

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
            
        case 5:
            if UserDefaults.standard.bool(forKey: "isLogged"){
                let settingsVC = UIStoryboard(name: "WishlistScreen", bundle: nil).instantiateViewController(withIdentifier: "wish")
                settingsVC.modalPresentationStyle = .fullScreen
                self.present(settingsVC, animated: true)
            }else{
                CustomAlert.showAlertView(view: self, title: "Need to Login", message: "log in to your account to enter the wishlist")
            }
            break
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            if orders?.count == 0{
                return 0
            }else {
                return 160
            }
        }
        if indexPath.row == 4{
            if orders?.count == 0 || orders?.count == 1{
                return 0
            }else{
                return 160
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
extension MeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: favCollectionView.frame.width * 0.5, height: favCollectionView.frame.height - 10)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if wishList?.lineItems?.count != 0{
            return wishList?.lineItems?.count ?? 0

        }
        collectionView.setEmptyMessage("Empty!")
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as!ProductCollectionViewCell
        cell.favButton.tintColor = .red
        cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)

        cell.favAction = {
            self.viewModel.editWishlist(draft: self.wishList, lineitem: self.wishList?.lineItems?[indexPath.row])
            self.wishList?.lineItems?.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        let url = URL(string: wishList?.lineItems?[indexPath.row].properties?[0].name ?? "")
        cell.productImage.kf.setImage(with: url!)
        cell.productPrice.text = "\(wishList?.lineItems?[indexPath.row].price ?? "") \(wishList?.currency ?? "")"
        cell.productTitle.text = wishList?.lineItems?[indexPath.row].title

        return cell
    }
}

