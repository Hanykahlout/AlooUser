//
//  PackagesViewController.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 04/12/2021.
//

import UIKit
import PassKit
class PackagesViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var packagesTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paymentButtonsStackView: UIStackView!
    @IBOutlet weak var paymentMethodView: UIViewCustomCornerRadius!
    private var link:String = ""
    private var stc:String = ""
    private var paymentPrice:String = ""
    private let presnter = PackagePresnter()
    private var data = [Packages]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        setupTableView()
        setupApplePay()
        presnter.delegate = self
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectShadowView)))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.getPackages()
    }
    
    private func setupApplePay(){
        let result = PaymentHandler.shard.applePayStatus()
        var button: UIButton?
        
        if result.canMakePayments {
            button = PKPaymentButton(paymentButtonType: .addMoney, paymentButtonStyle: .black)
            button?.addTarget(self, action: #selector(payPressed), for: .touchUpInside)
        } else if result.canSetupCards {
            button = PKPaymentButton(paymentButtonType: .addMoney, paymentButtonStyle: .black)
            button?.addTarget(self, action: #selector(setupPressed), for: .touchUpInside)
        }
        
        if let applePayButton = button {
            applePayButton.layer.cornerRadius = 10
            applePayButton.clipsToBounds = true
            
            let constraints = [
                applePayButton.heightAnchor.constraint(equalToConstant: 46)
            ]
            applePayButton.translatesAutoresizingMaskIntoConstraints = false
            paymentButtonsStackView.addArrangedSubview(applePayButton)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    
    @objc private func payPressed(){
        PaymentHandler.shard.startPayment(price:paymentPrice) { (success) in
            if success {
                self.shadowView.isHidden = true
                self.paymentMethodView.isHidden = true
            }
        }
    }
    
    @objc private func setupPressed(){
        shadowView.isHidden = true
        paymentMethodView.isHidden = true
    }
    
    
    @objc private func didSelectShadowView(){
        shadowView.isHidden = true
        paymentMethodView.isHidden = true
    }
   
    @IBAction func paymentAction(_ sender: UIButton) {
        shadowView.isHidden = true
        paymentMethodView.isHidden = true
    
        let vc = WebViewViewController()
        if sender.tag == 0{
            vc.link = link
        }else{
            vc.link = stc
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension PackagesViewController:UITableViewDelegate,UITableViewDataSource{
    private func setupTableView(){
        packagesTableView.delegate = self
        packagesTableView.dataSource = self
        
        packagesTableView.register(.init(nibName: "PackgesTableViewCell", bundle: nil), forCellReuseIdentifier: "PackgesTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackgesTableViewCell") as! PackgesTableViewCell
        cell.delegate = self
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
}

extension PackagesViewController:PackagePresnterDelegate,PackgesTableViewCellDelegate{
    func showCustomeAlertWithUrl(price:String,title: String, message: String,link:String,stc:String) {
        paymentPrice = price
        self.link = link
        self.stc = stc
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.shadowView.isHidden = false
            self.paymentMethodView.isHidden = false
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showCustomAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func setPackages(data: PackageData) {
        self.data = data.packages ?? []
        packagesTableView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
}
