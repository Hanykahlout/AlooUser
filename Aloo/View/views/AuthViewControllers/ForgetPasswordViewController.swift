//
//  ForgetPasswordViewController.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 06/12/2021.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    private let presnter = ForgetPasswordPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presnter.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if !phoneNumberTextField.text!.isEmpty{
            presnter.forgetPassword(phone: phoneNumberTextField.text!)
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is Empty Fields!!", comment: ""))
        }
    }
    
}

extension ForgetPasswordViewController:ForgetPasswordPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func showCustomAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            let vc = RestPasswordViewController()
            vc.phone = self.phoneNumberTextField.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
}
