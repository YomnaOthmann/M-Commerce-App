//
//  BrandScreenViewController.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import UIKit
import Kingfisher

class BrandScreenViewController: UIViewController , UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var brandProductsCollectionView: UICollectionView!
    
    var brand : String?
    var allProducts : [Product]?
    let viewModel = BrandScreenViewModel(network: NetworkManager())
    let defaults = UserDefaults.standard
    let indicator = UIActivityIndicatorView(style: .medium)
    var searchWords : String = ""
    var searching : Bool = false
    var wishlist : DraftOrder?
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = brand
        setUpCollectionView()
        brandProductsCollectionView.reloadData()
        setUpSearchBar()
        setUpIndicator()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
        viewModel.fetchProducts(brandName: brand)
            viewModel.bindResult = {
                self.allProducts = self.viewModel.brandProducts
                self.brandProductsCollectionView.reloadData()
            }
        viewModel.fetchWishlist()
        viewModel.bindWishlist = {
            if let wishlist = self.viewModel.wishlist{
                self.wishlist = wishlist
                self.brandProductsCollectionView.reloadData()
                self.indicator.stopAnimating()
            }
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
    fileprivate func setUpSearchBar() {
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
    }
    func setUpCollectionView(){
        
        brandProductsCollectionView.delegate = self
        brandProductsCollectionView.dataSource = self
        brandProductsCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        let brandLayout = UICollectionViewFlowLayout()
        brandLayout.scrollDirection = .vertical
        brandLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        brandProductsCollectionView.setCollectionViewLayout(brandLayout, animated: true)
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
            }
            if allProducts == nil{
                viewModel.fetchProducts(brandName: brand)
            }
            
        }else{
            if !alertIsPresenting{
                connectionAlert.showAlert(view: self)
                alertIsPresenting = true
            }
        }
    }
    @IBAction func gotoCart(_ sender: Any) {
        
        if defaults.bool(forKey: "isLogged"){
            let cartVC = UIStoryboard(name: "ShoppingBag", bundle: nil).instantiateViewController(withIdentifier: "cart")
            cartVC.modalPresentationStyle = .fullScreen
            self.present(cartVC, animated: true)
        }else{
            CustomAlert.showAlertView(view: self, title: "Need to Login", message: "log in to your account to enter the cart")
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gotoWishlist(_ sender: Any) {
        if defaults.bool(forKey: "isLogged"){
            let settingsVC = UIStoryboard(name: "WishlistScreen", bundle: nil).instantiateViewController(withIdentifier: "wish")
            settingsVC.modalPresentationStyle = .fullScreen
            self.present(settingsVC, animated: true)
        }else{
            CustomAlert.showAlertView(view: self, title: "Need to Login", message: "log in to your account to enter the wishlist")
        }
    
    }
}
extension BrandScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        if let lineItems = wishlist?.lineItems{
            for item in lineItems{
                if allProducts?[indexPath.row].title == item.title{
                    self.allProducts?[indexPath.row].isFav = true
                    break
                }else{
                    self.allProducts?[indexPath.row].isFav = false
                }
            }
        }
        if allProducts?[indexPath.row].images.count ?? -1 > 0{
            cell.productImage.kf.setImage(with: URL(string:allProducts?[indexPath.row].images[0].src ?? ""))
        }
        cell.productTitle.text = allProducts?[indexPath.row].title.components(separatedBy: "|  ").last?.capitalized
        cell.productPrice.text = (allProducts?[indexPath.row].variants[0].price ?? "" ) + " EGP"
        if defaults.bool(forKey: "isLogged"){
            cell.favButton.tintColor = viewModel.getButtonColor(isFav: self.allProducts?[indexPath.row].isFav)
            cell.favButton.setImage(viewModel.getButtonImage(isFav: self.allProducts?[indexPath.row].isFav), for: .normal)
        }
        cell.favAction = {
            if self.defaults.bool(forKey: "isLogged"){
                self.allProducts?[indexPath.row].isFav.toggle()
                print(self.allProducts?[indexPath.row].isFav)
                if ((self.allProducts?[indexPath.row].isFav) == true) {
                    print("fav")
                    self.viewModel.editWishlist(draft: self.wishlist, product: self.allProducts?[indexPath.row])
                    cell.favButton.tintColor = .red
                    cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }else{
                    self.viewModel.editWishlist(draft: self.wishlist, product: self.allProducts?[indexPath.row])
                    cell.favButton.tintColor = .black
                    cell.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }else{
                CustomAlert.showAlertView(view: self, title: "Need to Login", message: "log in to your account to add item to the wishlist")
                
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (brandProductsCollectionView.frame.width / 2) - 30, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Navigate to product details
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWords = searchBar.text ?? ""
        searchingResult()
    }
    
    func searchingResult() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            var filteredCollections: [Product]

            if self.searching {
                if self.searchWords.isEmpty {
                    filteredCollections = self.viewModel.brandProducts ?? []
                } else {
                    filteredCollections = self.viewModel.brandProducts?.filter {
                        $0.title.lowercased().contains(self.searchWords.lowercased())
                    } ?? []
                }
            } else {
                
                self.viewModel.fetchProducts(brandName: self.brand)
                return
            }

            DispatchQueue.main.async {
                self.allProducts = filteredCollections
                self.brandProductsCollectionView.reloadData()
            }
        }
    }

}
