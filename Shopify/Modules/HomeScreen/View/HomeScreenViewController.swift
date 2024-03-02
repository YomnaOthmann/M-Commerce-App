//
//  HomeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 24/02/2024.
//

import UIKit
import Kingfisher
import Lottie

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var brandHeaderLabel: UILabel!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandHeader: UILabel!
    @IBOutlet weak var brandsCollectionView: UICollectionView!

    
    @IBOutlet weak var homeSearchBar: UISearchBar!
    
    private var viewModel = HomeScreenViewModel(network: NetworkManager())
    let adsIndicator = UIActivityIndicatorView(style: .medium)
    let brandsIndicator = UIActivityIndicatorView(style: .medium)
    private var priceRules : PriceRules?
    private var discounts : DiscountCodes?
    private var smartCollections : SmartCollections?
    private let alert = ConnectionAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ShopLink"
        navigationItem.titleView?.tintColor = .customBlue
        brandHeaderLabel.isHidden = true
        setUpAdsCollectionView()
        setUpBrandsCollectionView()
        
        setUpIndicators()
        setUpSearchBar()
        viewModel.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.checkReachability(){
            brandHeaderLabel.isHidden = false
            viewModel.fetchAds()
            viewModel.fetchBrands()
        }else{
            brandHeaderLabel.isHidden = true
            ConnectionAlert().showAlert(view: self)
        }
        
        
    }
    
    fileprivate func setUpSearchBar() {
        homeSearchBar.tintColor = .white
        homeSearchBar.barTintColor = .white
        homeSearchBar.searchBarStyle = .minimal
        homeSearchBar.sizeToFit()
    }
    
    func setUpAdsCollectionView(){
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        
        let adsLayout = UICollectionViewFlowLayout()
        adsLayout.scrollDirection = .horizontal
        adsLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        adsCollectionView.setCollectionViewLayout(adsLayout, animated: true)
        
        adsCollectionView.isHidden = true
        adsCollectionView.register(AdsCollectionViewCell.nib(), forCellWithReuseIdentifier: AdsCollectionViewCell.id)
    }
    
    func setUpBrandsCollectionView(){
        
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .vertical
        brandsLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        brandsCollectionView.setCollectionViewLayout(brandsLayout, animated: true)
        brandsCollectionView.isHidden = true
        brandHeader.isHidden = true
        brandsCollectionView.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.id)
    }
    
    func setUpIndicators(){
        adsIndicator.color = .gray
        adsIndicator.hidesWhenStopped = true
        adsIndicator.center = adsCollectionView.center
        adsIndicator.startAnimating()
        view.addSubview(adsIndicator)
        
        brandsIndicator.color = .gray
        brandsIndicator.hidesWhenStopped = true
        brandsIndicator.center = brandsCollectionView.center
        brandsIndicator.startAnimating()
        view.addSubview(brandsIndicator)
    }
    
    @IBAction func gotoCart(_ sender: Any) {
        let cartVC = UIStoryboard(name: "ShoppingBag", bundle: nil).instantiateViewController(withIdentifier: "cart")
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: true)
        
    }
    
    @IBAction func gotoSettings(_ sender: Any) {
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsVC")
        settingsVC.modalPresentationStyle = .fullScreen
        self.present(settingsVC, animated: true)
    }
}

extension HomeScreenViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // TODO: - to be edited
        
        
    }
}
extension HomeScreenViewController : HomeScreenViewModelDelegate{
    
    func didLoadAds(ads: PriceRules) {
        priceRules = ads
        print("price \(priceRules?.priceRules?[0].id ?? 0)")
        viewModel.fetchDiscountCodes(priceRuleId: priceRules?.priceRules?[0].id ?? 0)
        viewModel.bindResult = {
            self.adsIndicator.stopAnimating()
            self.discounts = self.viewModel.discountCodes
            self.adsCollectionView.isHidden = false
            self.adsCollectionView.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.adsCollectionView.alpha = 1
            }
        }
        

    }
    func didLoadBrands(brands: SmartCollections) {
        smartCollections = brands
        brandsIndicator.stopAnimating()
        brandsCollectionView.reloadData()
        brandsCollectionView.isHidden = false
        brandHeader.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.brandsCollectionView.alpha = 1
        }
    }
    
}

extension HomeScreenViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case adsCollectionView:
            if self.discounts?.discountCodes?.count == 0 {
                             self.adsCollectionView.setEmptyMessage("No Discount Codes to show :(")
                         } else {
                             self.adsCollectionView.restore()
                         }
            return discounts?.discountCodes?.count ?? 0
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
            cell.clipsToBounds = true
            cell.adTitle.isHidden = true
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.id, for: indexPath) as? BrandCollectionViewCell else{
                return BrandCollectionViewCell()
            }
            // cell.brandName.text = smartCollections?.smartCollections[indexPath.row].title
            cell.brandImage.kf.setImage(with: URL(string: smartCollections?.smartCollections[indexPath.row].image.src ?? ""))
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == adsCollectionView{
            return CGSize(width: (adsCollectionView.frame.width) - 20 , height: 170)
        }
        else {
            return CGSize(width: brandsCollectionView.frame.width * 0.44 , height: brandsCollectionView.frame.height * 0.5)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandsCollectionView{
             // TODO: Add navigatoin code
            let brandVC = self.storyboard?.instantiateViewController(identifier: "brand") as! BrandScreenViewController
            brandVC.brand = smartCollections?.smartCollections[indexPath.row].title
            self.navigationController?.pushViewController(brandVC, animated: true)
        }
        if collectionView == adsCollectionView{
            UIPasteboard.general.string = discounts?.discountCodes?[indexPath.row].code ?? ""
            CustomAlert.showAlertView(view:self,title: "Congratulations", message: "You copied the discount code")
            showAnimation()
            viewModel.savePriceRule(priceRule: self.priceRules)
        }
    }
    
    func showAnimation(){
        let animationView : LottieAnimationView = LottieAnimationView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        
        animationView.center = self.view.center
        
        self.view.addSubview(animationView)
        guard let path = Bundle.main.path(forResource: "congrats", ofType: "json")else{
            return
        }
        let url = URL(fileURLWithPath: path)
        LottieAnimation.loadedFrom(url: url) { animation in
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            
            animationView.loopMode = .playOnce
            
            animationView.animationSpeed = 1.0
            
            animationView.play()
           
            
        }
 
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            animationView.stop()
            animationView.removeFromSuperview()
        }
    }
    
    
}
