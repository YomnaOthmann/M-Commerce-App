//
//  AddressesViewController.swift
//  Shopify
//
//  Created by Faisal TagEldeen on 24/02/2024.
//

import UIKit

class AddressesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var addressesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressesTableView.delegate=self
        addressesTableView.dataSource=self
        addressesTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryAddress", for: indexPath) as! AddressesTableViewCell
        
        cell.customerAddress.text = " iti-6 oct city,giza"
        cell.customerPhone.text = "0998877543456"
        
        return cell
    }
    
    
    @IBAction func backToPrevious(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {

      }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        let verticalPadding: CGFloat = 8
//
//        let maskLayer = CALayer()
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
//        
//        cell.layer.mask = maskLayer
//    }

    
 

}
