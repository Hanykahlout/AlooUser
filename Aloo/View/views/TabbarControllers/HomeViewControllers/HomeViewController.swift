//
//  HomeViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 22/09/2021.
//

import UIKit
import CoreLocation
class HomeViewController: UIViewController {

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var supermarketLabel: UILabel!
    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var restaurantsView: UIView!
    @IBOutlet weak var supermarketsView: UIView!
    @IBOutlet weak var pharmaciesView: UIView!
    @IBOutlet weak var resturantsImageView: UIImageView!
    @IBOutlet weak var superMarketsImageView: UIImageView!
    @IBOutlet weak var pharmaciesImageView: UIImageView!
    @IBOutlet weak var resturantWidthCons: NSLayoutConstraint!
    @IBOutlet weak var supermarketWidthCons: NSLayoutConstraint!
    @IBOutlet weak var pharmaciesWidthCons: NSLayoutConstraint!
    
    private let presnter = HomePresnter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presnter.getProviderData()

    }
    
    private func initlization(){
        presnter.delegate = self
        navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.string(forKey: "Token") == nil{
            let vc = storyboard?.instantiateViewController(withIdentifier: "OnBoardingNav") as! UINavigationController
            navigationController?.present(vc, animated: false, completion: nil)
        }
        restaurantsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectRestaurantsView)))
        supermarketsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSupermarketsView)))
        pharmaciesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectPharmaciesView)))
    }
    
    
    @objc private func didSelectRestaurantsView(){
        let vc = RestaurantsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    @objc private func didSelectSupermarketsView(){
        let vc = PharmaciesVC()
        UserDefaults.standard.setValue(true, forKey: "isMarket")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    @objc private func didSelectPharmaciesView(){
        let vc = PharmaciesVC()
        UserDefaults.standard.setValue(false, forKey: "isMarket")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
}


extension HomeViewController:HomePresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message )
    }
    
    func setProviderData(data: [Supported_vendors]) {
        for item in data {
            if item.id! == 1{
                supermarketLabel.text = item.description ?? ""
                superMarketsImageView.sd_setImage(with: URL(string: item.img ?? ""))
            }else if item.id! == 2{
                pharmacyLabel.text = item.description ?? ""
                pharmaciesImageView.sd_setImage(with: URL(string: item.img ?? ""))
            }else{
                restaurantLabel.text = item.description ?? ""
                resturantsImageView.sd_setImage(with: URL(string: item.img ?? ""))
            }
        }
    }
    
    
}
