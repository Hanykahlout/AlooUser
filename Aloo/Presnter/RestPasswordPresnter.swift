//
//  RestPasswordPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 06/12/2021.
//

import UIKit

protocol RestPasswordPresnterDelegate{
    func showAlert(title:String,message:String)
    func showCustomAlert(title:String,message:String)
}

typealias RestPasswordDelegate = RestPasswordPresnterDelegate & UIViewController

class RestPasswordPresnter:NSObject{
    weak var delegate:RestPasswordDelegate?
    
    func resetPassword(phone:String,password:String,code:String){
        AuthApiControllers.shard.resetPassword(phone: phone, code: code, password: password) { status, message in
            if status{
                DispatchQueue.main.async {
                    self.delegate?.showCustomAlert(title: NSLocalizedString("Error", comment: ""), message: message)
                }
            }else{
                DispatchQueue.main.async {
                    self.delegate?.showAlert(title: NSLocalizedString("Error", comment: ""), message: message)
                }
            }
        }
    }
}
