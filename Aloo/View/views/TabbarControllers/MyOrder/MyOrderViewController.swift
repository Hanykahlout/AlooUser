//
//  MyOrderViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 06/10/2021.
//

import UIKit

class MyOrderViewController: UIViewController {
    
    @IBOutlet weak var myOrderTableView: UITableView!
    
    private var data = [(image:UIImage,title:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    private func initlization(){
        setData()
        setUpTableView()
    }
    
    private func setData(){
        data.append((image: #imageLiteral(resourceName: "res-icon"), title: NSLocalizedString("Restaurant Orders", comment: "")))
        data.append((image: #imageLiteral(resourceName: "suma-icon"), title: NSLocalizedString("Super Market Orders", comment: "")))
        data.append((image: #imageLiteral(resourceName: "p-icon"), title: NSLocalizedString("Pharmacies Orders", comment: "")))
    }
    
    
}

extension MyOrderViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        myOrderTableView.delegate = self
        myOrderTableView.dataSource = self
        
        myOrderTableView.register(.init(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        cell.setData(image: data[indexPath.row].image, title: data[indexPath.row].title)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.string(forKey: "Token") != nil{
            let vc = ResturantOrderViewController()
            vc.supportedVendorId = getVendorId(index: indexPath.row)
            vc.supportedVendorName = getVendorName(index: indexPath.row)
            navigationController?.pushViewController( vc, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: LoginUserViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    private func getVendorId(index:Int) -> String{
        switch index {
        case 0:
            return "3"
        case 1:
            return "1"
        case 2:
            return "2"
        default:
            return ""
        }
    }
    
    private func getVendorName(index:Int) -> String{
        switch index {
        case 0:
            return NSLocalizedString("Restaurants", comment: "")
        case 1:
            return NSLocalizedString("SuperMarkets", comment: "")
        case 2:
            return NSLocalizedString("Pharmacys", comment: "")
        default:
            return ""
        }
    }
    
    
}
