//
//  HomeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var adsIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var brandsIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var homeSearchBar: UISearchBar!
    
    private var viewModel = HomeScreenViewModel(network: NetworkManager())
    
    private var priceRules : PriceRules?
    private var discounts : DiscountCodes?
    private var smartCollections : SmartCollections?
    private let alert = ConnectionAlert()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAdsCollectionView()
        setUpBrandsCollectionView()
        
        setUpIndicators()
        homeSearchBar.setTextFieldColor(.searchbar)
        
        viewModel.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
 
            viewModel.fetchAds()
            viewModel.fetchBrands()
       
    }
    
    func setUpAdsCollectionView(){
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        
        let adsLayout = UICollectionViewFlowLayout()
        adsLayout.scrollDirection = .horizontal
        adsLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        adsCollectionView.setCollectionViewLayout(adsLayout, animated: true)
        
        adsCollectionView.isHidden = true
        adsCollectionView.register(AdsCollectionViewCell.nib(), forCellWithReuseIdentifier: AdsCollectionViewCell.id)
    }
    
    func setUpBrandsCollectionView(){
        
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .horizontal
        brandsLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        adsCollectionView.setCollectionViewLayout(brandsLayout, animated: true)
        brandsCollectionView.isHidden = true
        brandsCollectionView.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.id)
    }
    
    func setUpIndicators(){
        adsIndicator.style = .medium
        adsIndicator.color = .customGray
        adsIndicator.hidesWhenStopped = true
        adsIndicator.startAnimating()
        
        brandsIndicator.style = .medium
        brandsIndicator.color = .customGray
        brandsIndicator.hidesWhenStopped = true
        brandsIndicator.startAnimating()
    }
    
   

}
extension HomeScreenViewController : HomeScreenViewModelDelegate{
    func didLoadAds(ads: PriceRules) {
        priceRules = ads
        adsIndicator.stopAnimating()
        adsCollectionView.reloadData()
        adsCollectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.adsCollectionView.alpha = 1
        }
    }
    
    func didLoadBrands(brands: SmartCollections) {
        smartCollections = brands
        brandsIndicator.stopAnimating()
        brandsCollectionView.reloadData()
        brandsCollectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.brandsCollectionView.alpha = 1
        }
    }
}

extension HomeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case adsCollectionView:
            return priceRules?.priceRules?.count ?? 0
        default:
            return smartCollections?.smartCollections.count ?? 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case adsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.id, for: indexPath) as? AdsCollectionViewCell else{
                return AdsCollectionViewCell()
            }
            cell.layer.cornerRadius = 12
            cell.adTitle.text = priceRules?.priceRules?[indexPath.row].title
            cell.adDescription.text = "\(priceRules?.priceRules?[indexPath.row].targetSelection?.uppercased() ?? "") Items"
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.id, for: indexPath) as? BrandCollectionViewCell else{
                return BrandCollectionViewCell()
            }
            cell.brandName.text = smartCollections?.smartCollections[indexPath.row].title
            cell.brandImage.kf.setImage(with: URL(string: smartCollections?.smartCollections[indexPath.row].image.src ?? ""))
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch collectionView{
        case adsCollectionView:
            guard let header = adsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiscountHeaderReusableView.id, for: indexPath) as? DiscountHeaderReusableView else{
                return UICollectionReusableView()
            }
            header.headerLabel.text = "Discounts"
            print("discount header")
            return header

        default:
            guard let header = brandsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BrandHeadeReusableView.id, for: indexPath) as? BrandHeadeReusableView else{
                return UICollectionReusableView()
            }
            header.brandLabel.text = "Brands"
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == adsCollectionView{
            return CGSize(width: (UIScreen.main.bounds.width) - 50 , height: 200)
        }
        else if collectionView == brandsCollectionView{
            return CGSize(width: 150, height: 200)
        }
        return CGSize(width: (UIScreen.main.bounds.width) / 2 , height: 200)
    }
}
