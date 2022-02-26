//
//  CartViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit
import PassKit
class CartViewController: UIViewController {
    
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var askingPriceLabel: UILabel!
    @IBOutlet weak var deliveryCharge: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var cartMealsTableView: UITableView!
    @IBOutlet weak var signUpNowView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paymentMethodView: UIView!
    @IBOutlet weak var paymentButtonsStackView: UIStackView!
    
    
    
    public var isRestaurant = true
    
    private var link:String = ""
    private var stc:String = ""
    private var data = [CartItems]()
    private let presnter = CartPresnter()
    private var supportedVendorId = ""
    private var selectedPlaceId:String?
    private var totalPrice = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        inilization()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressLabel.text = UserDefaults.standard.string(forKey: "SelectedPlaceName") ?? ""
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        supportedVendorId = isRestaurant ?"3" : UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2"
        presnter.getCartData(id: supportedVendorId)
        
    }
    
    
    private func inilization(){
        addressLabel.text = ""
        presnter.delegate = self
        setUpTableViews()
        setupApplePay()
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectShadowView)))
        
    }
    
    private func setupApplePay(){
        let result = PaymentHandler.shard.applePayStatus()
        var button: UIButton?
        
        if result.canMakePayments {
            button = PKPaymentButton(paymentButtonType: .addMoney, paymentButtonStyle: .black)
            button?.addTarget(self, action: #selector(payPressed), for: .touchUpInside)
        } else if result.canSetupCards {
            button = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
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
        PaymentHandler.shard.startPayment(price:totalPrice) { (success) in
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
        self.shadowView.isHidden = true
        self.signUpNowView.isHidden = true
        paymentMethodView.isHidden = true
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignUpNowAction(_ sender: Any) {
        self.shadowView.isHidden = true
        self.signUpNowView.isHidden = true
        let loginNav = UINavigationController(rootViewController: LoginUserViewController())
        loginNav.modalPresentationStyle = .fullScreen
        loginNav.navigationBar.isHidden = true
        navigationController?.present(loginNav, animated: true, completion: nil)
    }
    
    
    @IBAction func conformationAction(_ sender: Any) {
        if !data.isEmpty{
            if UserDefaults.standard.string(forKey: "Token") != nil{
                presnter.submitCart(placeId: UserDefaults.standard.string(forKey: "SelectedPlaceId") ?? "", supportedVendorId: supportedVendorId)
            }else{
                self.shadowView.isHidden = false
                self.signUpNowView.isHidden = false
            }
        }else{
            self.showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is no item in the cart", comment: ""))
        }
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
    
    
    
}


extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableViews(){
        cartMealsTableView.delegate = self
        cartMealsTableView.dataSource = self

        cartMealsTableView.register(.init(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        cartMealsTableView.register(.init(nibName: "PharmacyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "PharmacyCartTableViewCell")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if isRestaurant{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
                cell.delegate = self
                cell.setData(data: data[indexPath.row])
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCartTableViewCell", for: indexPath) as! PharmacyCartTableViewCell
                cell.delegate = self
                cell.setData(data: data[indexPath.row])
                return cell
            }
        
    }
    
}

extension CartViewController:CartPresnterDelegate{
    func showSuccessAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true)
    }
    
    
    func deleteMealFromTableView(indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        cartMealsTableView.deleteRows(at: [indexPath], with: .left)
        noItemLabel.isHidden = !data.isEmpty
    }
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
    func showCustomAlert(title:String,message:String,link:String,stc:String){
        self.link = link
        self.stc = stc
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.shadowView.isHidden = false
            self.paymentMethodView.isHidden = false
        }))
        present(alertVC, animated: true)
    }
    
    
    func cartData(data: CartDataReponse) {
        
        self.data = data.cart?.items ?? []
        cartMealsTableView.reloadData()
        let delivaryCharge = Double(data.cart?.delivery_price_reservation ?? 0)
        let askingPrice = Double(data.cart?.total ?? 0)
        askingPriceLabel.text = "\(data.cart?.total ?? 0) \(NSLocalizedString("SR", comment: ""))"
        deliveryCharge.text = "\(String(delivaryCharge)) \(NSLocalizedString("SR", comment: ""))"
        totalPrice = String(delivaryCharge + askingPrice)
        totalLabel.text = "\(totalPrice) \(NSLocalizedString("SR", comment: ""))"
        noItemLabel.isHidden = !self.data.isEmpty

    }


    
}

extension CartViewController:CartTableViewCellDelegate{
    
    func deleteMealFromCart(id: String,indexPath:IndexPath) {
        presnter.deleteItem(id: id,indexPath: indexPath)
    }
    
    
    func goToMealViewController(id:String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MealDetailsViewController") as! MealDetailsViewController
        vc.isEdit = true
        vc.itemId = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension CartViewController: PharmacyCartTableViewCellDelegate{
    func goToEditProduct(id: String) {
        let vc = ProductDetailsViewController()
        vc.id = id
        vc.isEdit = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
