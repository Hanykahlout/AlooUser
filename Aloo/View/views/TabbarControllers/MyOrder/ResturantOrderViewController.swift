//
//  ResturantOrder.swift
//  Aloo
//
//  Created by macbook on 9/29/21.
//

import UIKit

class ResturantOrderViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var resturantOrderTableView: UITableView!
    
    @IBOutlet weak var headerLabel: UILabel!
    public var supportedVendorId:String!
    public var supportedVendorName = ""
    private var items = [ShowOrdersItems]()
    private var presnter = ResturantOrderPresnter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        presnter.delegate = self
        setUpTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            headerLabel.text = "\(NSLocalizedString("Orders", comment: "")) \(supportedVendorName)"
        }else{
            headerLabel.text = "\(supportedVendorName) \(NSLocalizedString("Orders", comment: ""))"
        }
        
        presnter.showAllOrders(supportedVendorId: supportedVendorId)
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ResturantOrderViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        resturantOrderTableView.delegate = self
        resturantOrderTableView.dataSource = self
        resturantOrderTableView.register(.init(nibName: "ResturantOrder", bundle: nil), forCellReuseIdentifier: "ResturantOrder")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResturantOrder", for: indexPath) as! ResturantOrder
        cell.setData(data: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroyboard.instantiateViewController(withIdentifier: "CartPageViewController") as! CartPageViewController
        vc.vendor = items[indexPath.row]
        vc.supportedVendorName = getVendorName(number: supportedVendorId)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func getVendorName(number:String) -> String{
        switch number {
        case "1":
            return NSLocalizedString("SuperMarket", comment: "")
        case "2":
            return NSLocalizedString("Pharmacy", comment: "")
        case "3":
            return NSLocalizedString("Restaurant", comment: "")
            
        default:
            return ""
        }
    }
    
}

extension ResturantOrderViewController:ResturantOrderPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func AllOrderItems(items: [ShowOrdersItems]) {
        self.items = items
        resturantOrderTableView.reloadData()
    }
    
    
    
    
    
}
