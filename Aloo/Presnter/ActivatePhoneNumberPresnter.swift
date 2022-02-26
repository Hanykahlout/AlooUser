//
//  ActivatePhoneNumberPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/10/2021.
//

import UIKit

protocol ActivatePhoneNumberPresnterDelegate {
    func showAlert(title:String,message:String)
    func showSuccessAlert()
}

typealias ActivatePhoneNumberDelegate = ActivatePhoneNumberPresnterDelegate & UIViewController

class ActivatePhoneNumberPresnter:NSObject{
    
    weak var delegate:ActivatePhoneNumberDelegate?
    
    func phoneNumberVerfication(phoneNumber:String,verifyCode:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                AuthApiControllers.shard.verifyPhone(phone: phoneNumber, verify_code: verifyCode) { data , status, message in
                    if status{
                        if let data = data{
                            UserDefaults.standard.setValue("Bearer \(data.token?.access_token ?? "")", forKey: "Token")
                            DispatchQueue.main.async {
                                self.delegate?.showSuccessAlert()
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
    
    func resendCode(phone:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                AuthApiControllers.shard.resendCode(phone: phone) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("The code has been successfully sent back", comment: ""), message: "")
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
