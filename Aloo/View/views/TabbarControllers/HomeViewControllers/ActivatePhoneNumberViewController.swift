//
//  ActivatePhoneNumberViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit

class ActivatePhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var activationView: UIViewCustomCornerRadius!
    @IBOutlet weak var activationCodeTextField: UITextField!
    
    public var phoneNumber:String!
    private var presnter = ActivatePhoneNumberPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    private func initlization(){
        presnter.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewAction)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    @objc private func viewAction(){
        activationCodeTextField.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        presnter.phoneNumberVerfication(phoneNumber: phoneNumber, verifyCode: activationCodeTextField.text!)
    }
    
    
    @IBAction func okAction(_ sender: Any) {
        self.shadowView.isHidden = true
        self.activationView.isHidden = true
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resendAction(_ sender: Any) {
        presnter.resendCode(phone: phoneNumber)
    }
    
    
}

extension ActivatePhoneNumberViewController:ActivatePhoneNumberPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func showSuccessAlert() {
        viewAction()
        GeneralActions.shard.sendFCMTokenToServer()
        self.shadowView.isHidden = false
        self.activationView.isHidden = false
    }
    
    
}
