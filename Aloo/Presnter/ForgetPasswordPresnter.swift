//
//  ForgetPasswordPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 06/12/2021.
//

import UIKit

protocol ForgetPasswordPresnterDelegate{
    func showAlert(title:String,message:String)
    func showCustomAlert(title:String,message:String)
}


typealias ForgetPasswordDelegate = ForgetPasswordPresnterDelegate & UIViewController

class ForgetPasswordPresnter:NSObject{
    
    weak var delegate:ForgetPasswordDelegate?
    
    
    func forgetPassword(phone:String){
        AuthApiControllers.shard.forgetPassword(phone: phone) { status, message in
            if status{
                DispatchQueue.main.async {
                    self.delegate?.showCustomAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                }
            }else{
                DispatchQueue.main.async {
                    self.delegate?.showAlert(title: NSLocalizedString("Error", comment: ""), message: message)
                }
            }
        }
    }
    
    
}
