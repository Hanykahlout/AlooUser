//
//  CartPagePresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 13/11/2021.
//

import UIKit

protocol CartPagePresnterDelegate {
    func showAlert(title:String,message:String)
    func OrderData(data:OrderData)
}


typealias CartPageDelegate = CartPagePresnterDelegate & UIViewController


class CartPagePresnter:NSObject{
    
    weak var delegate:CartPageDelegate?
    
    
    func showOrder(vendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.showOrder(id: vendorId) { data in
                    if let data = data{
                        DispatchQueue.main.async {
                            self.delegate?.OrderData(data: data)
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
