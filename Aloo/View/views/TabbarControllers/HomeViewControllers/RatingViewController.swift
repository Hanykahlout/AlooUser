//
//  RatingViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var submittedRateView: UIViewCustomCornerRadius!
    @IBOutlet weak var shadowView: UIView!
    
    public var vendor:ShowOrdersItems?
    public var name = ""
    private let presnter = RatingPresnter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    private func initlization(){
        ratingView.rating = 0.0
        presnter.delegate = self
        shadowView.isUserInteractionEnabled = true
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectShadowView)))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        headerLabel.text = name
        if let vendor = vendor{
            driverImage.sd_setImage(with: URL(string: vendor.vendor?.logo ?? ""))
            driverNameLabel.text = vendor.vendor?.name ?? ""
        }
    }
    
    
    @objc private func didSelectShadowView(){
        shadowView.isHidden = true
        submittedRateView.isHidden = true
    }
    
    @IBAction func okAction(_ sender: Any) {
        didSelectShadowView()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitRatingAction(_ sender: Any) {
        if let vendor = vendor{
            presnter.rateVendor(id: String(vendor.id ?? -1), rate: ratingView.rating, message: noteTextView.text!)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RatingViewController:RatingPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func successfullyRatedAction() {
        self.shadowView.isHidden = false
        self.submittedRateView.isHidden = false
    }
    
    
    
    
    
    
}
