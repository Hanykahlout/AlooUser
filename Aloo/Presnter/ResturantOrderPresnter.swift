//
//  ResturantOrderPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 13/11/2021.
//

import UIKit


protocol ResturantOrderPresnterDelegate {
    func showAlert(title:String,message:String)
    func AllOrderItems(items:[ShowOrdersItems])
}

typealias ResturantOrderDelegate = ResturantOrderPresnterDelegate & UIViewController


class ResturantOrderPresnter: NSObject {
    weak var delegate:ResturantOrderDelegate?
    
    
    func showAllOrders(supportedVendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.getServiceProvider(id: supportedVendorId) { status, data, message in
                    if status{
                        if let items = data?.items{
                            DispatchQueue.main.async {
                                self.delegate?.AllOrderItems(items: items)
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
