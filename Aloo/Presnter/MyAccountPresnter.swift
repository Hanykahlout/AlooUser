//
//  MyAccountPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/10/2021.
//

import UIKit

protocol MyAccountPresnterDelegate {
    func showAlert(title:String,message:String)
    func logoutAction()
}

typealias MyAccountDelegate = MyAccountPresnterDelegate & UIViewController

class MyAccountPresnter:NSObject{
    
    weak var delegate:MyAccountDelegate?
    
    func logout(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                AuthApiControllers.shard.logout { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.logoutAction()
                        }
                    }else{
                        if message == "Unauthorized"{
                            DispatchQueue.main.async {
                                self.delegate?.logoutAction()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.delegate?.showAlert(title: NSLocalizedString("Error", comment: ""), message: message)
                            }
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
