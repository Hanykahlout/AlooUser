//
//  LoginViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit

class LoginUserViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var presnter = LoginPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    
    private func initlization(){
        presnter.delegate = self
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        presnter.loginAction(phone: phoneNumberTextField.text!, password: passwordTextField.text!)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let nav = UINavigationController(rootViewController: ForgetPasswordViewController())
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        navigationController?.present(nav, animated: true, completion: nil)
    }
    
}

extension LoginUserViewController:LoginPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func successLoginAction() {
        if !UserDefaults.standard.bool(forKey: "firstLogin"){
            GeneralActions.shard.sendFCMTokenToServer()
            UserDefaults.standard.setValue(true, forKey: "firstLogin")
            navigationController?.pushViewController(PackageViewController(), animated: true)
        }else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
