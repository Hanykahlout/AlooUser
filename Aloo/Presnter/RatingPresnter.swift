//
//  RatingPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 16/11/2021.
//

import UIKit

protocol RatingPresnterDelegate {
    func showAlert(title:String,message:String)
    func successfullyRatedAction()
}

typealias RatingDelegate = RatingPresnterDelegate & UIViewController

class RatingPresnter:NSObject{
    
    weak var delegate:RatingDelegate?
    
    func rateVendor(id:String,rate:Double,message:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.rateVendor(id: id, rate: rate, message: message) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.successfullyRatedAction()
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
