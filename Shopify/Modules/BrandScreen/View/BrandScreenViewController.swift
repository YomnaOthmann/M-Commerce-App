//
//  BrandScreenViewController.swift
//  Shopify
//
//  Created by Mac on 25/02/2024.
//

import UIKit
import Kingfisher

class BrandScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var brandProductsCollectionView: UICollectionView!
    
    var brand : String?
    var allProducts : [Product]?
    let viewModel = BrandScreenViewModel(network: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = brand
        setUpCollectionView()
        brandProductsCollectionView.reloadData()
        setUpSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.checkReachability(){
            ConnectionAlert().dismissAlert()
            viewModel.fetchProducts(brandName: brand)
            viewModel.bindResult = {
                self.allProducts = self.viewModel.brandProducts
                self.brandProductsCollectionView.reloadData()
            }
        }else{
            ConnectionAlert().showAlert(view: self)
        }
        
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
    
}
extension BrandScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        if allProducts?[indexPath.row].images.count ?? -1 > 0{
            cell.productImage.kf.setImage(with: URL(string:allProducts?[indexPath.row].images[0].src ?? ""))
        }
        
        cell.productTitle.text = allProducts?[indexPath.row].title.components(separatedBy: "|  ").last?.capitalized
        cell.productPrice.text = (allProducts?[indexPath.row].variants[0].price ?? "" ) + " EGP"
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
}
