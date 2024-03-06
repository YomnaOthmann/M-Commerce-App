//
//  WishlistViewController.swift
//  Shopify
//
//  Created by Mac on 04/03/2024.
//

import UIKit
import Kingfisher
class WishlistViewController: UIViewController {

    let connectionAlert = ConnectionAlert()
    var alertIsPresenting = false
    var timer : Timer?
    var wishList : DraftOrder?
    let indicator = UIActivityIndicatorView(style: .medium)
    let viewModel = WishlistScreenViewModel(network: NetworkManager())
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpIndicator()
        viewModel.fetchWishlist()
        viewModel.bindResult = {
            self.wishList = self.viewModel.wishlist
            self.indicator.stopAnimating()
            self.wishlistCollectionView.reloadData()
        }
    }
    
    func setUpCollectionView(){
        
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.id)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        wishlistCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    func setUpIndicator(){
        indicator.center = view.center
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension WishlistViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if wishList?.lineItems?.count != 0{
            return wishList?.lineItems?.count ?? 0

        }
        collectionView.setEmptyMessage("No items in wishlist!!")
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.id, for: indexPath) as! ProductCollectionViewCell
        //let url = URL(string: wishList?.lineItems?[indexPath.row].properties?[0].name ?? "")
        //cell.productImage.kf.setImage(with: url!)
        cell.productPrice.text = "\(wishList?.lineItems?[indexPath.row].price ?? "") \(wishList?.currency ?? "")"
        cell.productTitle.text = wishList?.lineItems?[indexPath.row].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (wishlistCollectionView.frame.width / 2) - 30, height: 300)
    }

}
