//
//  CartPageViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 06/10/2021.
//

import UIKit

class CartPageViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderStatusValueLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var askedPriceLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var topTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var ordersTableViewHeightConstrant: NSLayoutConstraint!
    
    public var vendor:ShowOrdersItems?
    public var supportedVendorName = ""
    private var orderData = [OrderItems]()
    
    private let presnter = CartPagePresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            headerLabel.text = "طلبات \(supportedVendorName)"
        }else{
            headerLabel.text = "\(supportedVendorName) Order"
        }
        
        if let vendor = vendor{
            presnter.showOrder(vendorId: String(vendor.id ?? -1))
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trackingOrderButton(_ sender: Any) {
        let vc = TrakingViewController()
        vc.vendor = self.vendor
        vc.supportedVendorName = self.supportedVendorName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension CartPageViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        ordersTableView.register(.init(nibName: "OrderSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryTableViewCell", for: indexPath) as! OrderSummaryTableViewCell
        cell.setData(data: orderData[indexPath.row])
        return cell
    }
    
    
}

extension CartPageViewController:CartPagePresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func OrderData(data: OrderData) {
        orderData = data.items ?? []
        ordersTableViewHeightConstrant.constant = CGFloat(orderData.count * 128)
        ordersTableView.reloadData()
        timeLabel.text = String(data.date ?? 0)
        orderNumberLabel.text = String(data.id ?? -1)
        orderStatusValueLabel.text = data.status ?? ""
        fromLocationLabel.text = data.place?.name ?? ""
        toLocationLabel.text = data.place?.location_name ?? ""
        askedPriceLabel.text = String(data.total?.price ?? 0.0)
        deliveryChargeLabel.text = String(data.total?.price ?? 0.0)
        totalLabel.text = String(data.total?.total ?? 0.0)
        topTotalLabel.text = String(data.total?.total ?? 0.0)
    }
    
    
    
    
}
