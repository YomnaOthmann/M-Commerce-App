//
//  MeScreenViewController.swift
//  Shopify
//
//  Created by Mac on 26/02/2024.
//

import UIKit

class MeScreenViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        userView.layer.cornerRadius = 20
        userName.text = "Yomna Othman"
        userMail.text = "yomnaothmann@gmail.com"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToWhishlist(_ sender: Any) {
    }
    
    @IBAction func back(_ sender: Any) {
    }
    
    @IBAction func goToCart(_ sender: Any) {
    }
}
extension MeScreenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "Orders"
        default:
            cell.textLabel?.text = "Settings"
        }
        cell.textLabel?.font = UIFont(name: "MontserratMedium", size: 18)
        cell.layer.cornerRadius = 10
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            //TODO: Navigate to Orders Screen
            print("")
        default:
            // TODO: Navigate to Settings Screen
            print("")
        }
    }
    
    
}
