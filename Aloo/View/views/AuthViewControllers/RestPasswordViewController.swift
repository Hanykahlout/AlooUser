//
//  RestPasswordViewController.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 06/12/2021.
//

import UIKit

class RestPasswordViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    public var phone:String!
    private let presnter = RestPasswordPresnter()
    
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
    
    
    @IBAction func restAction(_ sender: Any) {
        if !codeTextField.text!.isEmpty && !passwordTextField.text!.isEmpty{
            presnter.resetPassword(phone: phone, password: passwordTextField.text!, code: codeTextField.text!)
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is Empty Fields!!", comment: ""))
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension RestPasswordViewController:RestPasswordPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func showCustomAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
