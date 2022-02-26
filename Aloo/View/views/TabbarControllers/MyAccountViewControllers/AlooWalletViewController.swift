//
//  AlooWalletViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit

class AlooWalletViewController: UIViewController {
    
    @IBOutlet weak var cancelPackageButton: UIButton!
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var packageButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var packageIdLabel: UILabel!
    @IBOutlet weak var numberOfOrderInPackageLabel: UILabel!
    @IBOutlet weak var packageDiscountLabel: UILabel!
    @IBOutlet weak var packageDurationLabel: UILabel!
    
    private let presnter = WalletPresenter()
    private var id:String = ""
    private var walletDetailsData:[Wallet_details] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.wallet()
    }
    
    private func goToPackagesViewController(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "PackagesViewController") as! PackagesViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func viewAllPackageAction(_ sender: Any) {
        goToPackagesViewController()
    }
    
    @IBAction func packageButtonAction(_ sender: Any) {
        goToPackagesViewController()
    }
    
    @IBAction func cancelPackageAction(_ sender: Any) {
        presnter.cancelPackage(id: id)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


extension AlooWalletViewController:UITableViewDelegate,UITableViewDataSource{
    private func setTableView(){
        walletTableView.delegate = self
        walletTableView.dataSource = self
        
        walletTableView.register(.init(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletDetailsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        cell.setData(data: walletDetailsData[indexPath.row])
        return cell
    }
    
    
}

extension AlooWalletViewController:WalletPresenterDelegate{
    func cancelPackageSuccessAction() {
        packageButton.isHidden = false
        packageView.isHidden = true
        cancelPackageButton.isHidden = true
    }
    
    func walletDetails(data: UserWalletData) {
        balanceLabel.text = "\(data.wallet?.amount ?? "") \(NSLocalizedString("SR", comment: ""))"
        walletDetailsData = data.wallet_details ?? []
        walletTableView.reloadData()
        if let package = data.packages?.first{
            packageButton.isHidden = true
            packageView.isHidden = false
            cancelPackageButton.isHidden = false
            id = String(package.id ?? -1)
            packageIdLabel.text = "\(NSLocalizedString("Aloo", comment: "")) \(package.id ?? -1)"
            packagePriceLabel.text = "\(package.price ?? "") \(NSLocalizedString("SR", comment: ""))"
            numberOfOrderInPackageLabel.text = "\(NSLocalizedString("Number Of Monthly Orders:", comment: "")) \(package.orders ?? "") \(NSLocalizedString("Orders", comment: ""))"
            packageDiscountLabel.text = "\(NSLocalizedString("Discount Coupon:", comment: "")) \(package.discount ?? "")"
            packageDurationLabel.text = "\(NSLocalizedString("Package Duration:", comment: "")) \(package.days ?? "") \(NSLocalizedString("day", comment: ""))"
        }else{
            packageButton.isHidden = false
            packageView.isHidden = true
            cancelPackageButton.isHidden = true
        }
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
}
