//
//  CategoryScreenViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class CategoryScreenViewController: UIViewController {
    
    var allProducts : [Product]?
    var filteredProducts : [Product]?
    var customCollection : [CustomCollection]?
    var timer : Timer?
    let indicator = UIActivityIndicatorView(style: .medium)
    let subCategories = [
        UIImage(named: "all"),
        UIImage(named: "shoes"),
        UIImage(named: "tShirt"),
        UIImage(named: "handbags")
    ]
    var mainCategory = "all"
    var subCategory : Product.ProductType = .all
    let viewModel = CategoryScreenViewModel(network: NetworkManager())
    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    let defaults = UserDefaults.standard

    
    var searchWords : String = ""
    var searching : Bool = false
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    
    
//    self.allProducts = self.viewModel.allProducts?.products
//    self.filteredProducts = self.allProducts
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIndicator()
        setUpFilterCollectionView()
        setUpCategoryCollectionView()
        setUpSearchBar()
        viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        viewModel.fetchProducts()
        viewModel.bindResult = {
            self.allProducts = self.viewModel.allProducts?.products
            self.filteredProducts = self.allProducts
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
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
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    func setUpCategoryCollectionView(){
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        categoryCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    func setUpFilterCollectionView(){
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterCollectionViewCell.nib(), forCellWithReuseIdentifier: FilterCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        filterCollectionView.setCollectionViewLayout(layout, animated: true)
        filterCollectionView.reloadData()
    }
    fileprivate func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
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
            
        }else{
            if !alertIsPresenting{
                connectionAlert.showAlert(view: self)
                alertIsPresenting = true
            }
        }
    }
    
    @IBAction func getAllItems(_ sender: Any) {
        guard let products = allProducts else{
            return
        }
        mainCategory = "all"
        filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
        categoryCollectionView.reloadData()
    }
    @IBAction func getWomenItems(_ sender: Any) {
        guard let products = allProducts else{
            return
        }
        mainCategory = "women"
        filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
        categoryCollectionView.reloadData()
    }
    @IBAction func getMenItems(_ sender: Any) {
        guard let products = allProducts else{
            return
        }
        mainCategory = "men"
        filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
        categoryCollectionView.reloadData()
    }
    @IBAction func getKidsItems(_ sender: Any) {
        guard let products = allProducts else{
            return
        }
        mainCategory = "kid"
        filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
        categoryCollectionView.reloadData()
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
    @IBAction func gotoSettings(_ sender: Any) {
        if defaults.bool(forKey: "isLogged"){
            let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
            settingsVC.modalPresentationStyle = .fullScreen
            self.present(settingsVC, animated: true)
        }else{
            CustomAlert.showAlertView(view: self, title: "Need to Login", message: "log in to your account to enter the setttings")
        }
    }
}
extension CategoryScreenViewController : UISearchBarDelegate{
    
    
    
    
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

               var filteredProducts: [Product]

               if self.searching {
                   if self.searchWords.isEmpty {
                       // If the search query is empty, show all products
                       filteredProducts = self.allProducts ?? []
                   } else {
                       // Filter products based on the search query
                       filteredProducts = self.allProducts?.filter {
                           $0.title.lowercased().contains(self.searchWords.lowercased())
                       } ?? []
                   }
               } else {
                   // If not searching, show all products
                   filteredProducts = self.allProducts ?? []
               }

               DispatchQueue.main.async {
                   self.filteredProducts = filteredProducts
                   self.categoryCollectionView.reloadData()
               }
           }
       }


}
extension CategoryScreenViewController: CategoryScreenViewModelDelegate {
    func setFilteredProducts() {
        
    }
    
    func setFilteredProducts(filteredProducts: [Product]) {
        self.filteredProducts = filteredProducts
        self.categoryCollectionView.reloadData()
    }
}

extension CategoryScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView{
            return subCategories.count
        }
        else{
            if self.filteredProducts?.count == 0 {
                self.categoryCollectionView.setEmptyMessage("Nothing to show :(")
            } else {
                self.categoryCollectionView.restore()
            }
            return filteredProducts?.count ?? 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == filterCollectionView{
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.id, for: indexPath) as! FilterCollectionViewCell
            cell.filterImage.image = subCategories[indexPath.row]
            return cell
            
        }else{
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
            if filteredProducts?[indexPath.row].images.count ?? -1 > 0{
                cell.productImage.kf.setImage(with: URL(string: filteredProducts?[indexPath.row].images[0].src ?? ""))
            }
            cell.productTitle.text = filteredProducts?[indexPath.row].title.components(separatedBy: "    ").last?.capitalized
            cell.productPrice.text = (filteredProducts?[indexPath.row].variants[0].price ?? "") + " EGP"
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView{
            return CGSize(width: 80, height: 80)
        }else{
            return CGSize(width: (categoryCollectionView.frame.width / 2) - 30, height: 300)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let products = allProducts else{
            return
        }
        if collectionView == filterCollectionView{
            switch indexPath.row{
            case 0:
                subCategory = Product.ProductType.all
                filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
            case 1:
                subCategory = Product.ProductType.shoes
                filteredProducts = viewModel.filterProducts(products: products,  mainCategory: mainCategory,subCategory: subCategory)
            case 2:
                subCategory = Product.ProductType.tShirts
                filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
            default:
                subCategory = Product.ProductType.accessories
                filteredProducts = viewModel.filterProducts(products: products, mainCategory: mainCategory,subCategory: subCategory)
            }
            categoryCollectionView.reloadData()
            
        }else{
            // TODO: Navigate to product details here
        }
        
    }
}
