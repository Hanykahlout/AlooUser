//
//  LoginPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/10/2021.
//

import UIKit
import FirebaseMessaging

protocol LoginPresnterDelegate {
    func showAlert(title:String,message:String)
    func successLoginAction()
}

typealias LoginDelegate = LoginPresnterDelegate & UIViewController


class LoginPresnter:NSObject{
    
    weak var delegate:LoginDelegate?
    
    func loginAction(phone: String,password:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                AuthApiControllers.shard.Login(phone: phone, password: password) { data, status, message in
                    if status{
                        if let data = data{
                            UserDefaults.standard.setValue("Bearer \(data.token?.access_token ?? "")", forKey: "Token")
                            DispatchQueue.main.async {
                                self.delegate?.successLoginAction()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Error", comment: ""), message: message)
                        }
                    }
                }
            }
        } notConectedAction: {
            DispatchQueue.main.async {
                self.delegate?.showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Internet Connection Error", comment: ""))
            }
        }
    }
    
}




