//
//  TrakingViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit

class TrakingViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var firstStepLabel: UILabel!
    @IBOutlet weak var secondStepLabel: UILabel!
    
    @IBOutlet var numbersLabels: [UILabel]!
    
    @IBOutlet var activationPathsImageViews: [UIImageView]!
    
    @IBOutlet weak var rateButton: GraidentButton!
    
    public var vendor:ShowOrdersItems!
    public var supportedVendorName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    private func initlization(){
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTrackingAction()
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            for image in activationPathsImageViews{
                image.transform = .init(rotationAngle: .pi)
            }
            
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func handleTrackingAction(){
        RealTimeDatabase.shard.getStatusValue(id: String(vendor.id!)) { status in
            DispatchQueue.main.async {
                self.trak(number: status)
                if status == 6 {
                    self.titleLabel.text = NSLocalizedString("The order has been confirmed by the restaurant, please pay to prepare the order", comment: "")
                    self.rateButton.isHidden = false
                }else{
                    self.rateButton.isHidden = true
                }
            }
        }
    }
    
    
    private func trak(number:Int){
        for index in 0..<numbersLabels.count {
            numbersLabels[index].backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.1098039216, blue: 0.1137254902, alpha: 1)
            numbersLabels[index].textColor = .white
            if index != 5{
                activationPathsImageViews[index].image = #imageLiteral(resourceName: "activations-Path")
            }
            if number == Int(numbersLabels[index].text!){
                break
            }
        }
    }
    
    
    @IBAction func rateAction(_ sender: Any) {
        if let vendor = vendor{
            let vc = RatingViewController()
            vc.vendor  = vendor
            if L102Language.currentAppleLanguage() == "ar"{
                vc.name = "\(NSLocalizedString("Rate", comment: "")) \(supportedVendorName)"
            }else{
                vc.name = "\(supportedVendorName) \(NSLocalizedString("Rate", comment: ""))"
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
