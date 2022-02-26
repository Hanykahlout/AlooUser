//
//  HomePresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 16/11/2021.
//

import UIKit
protocol HomePresnterDelegate {
    func showAlert(title:String,message:String)
    func setProviderData(data:[Supported_vendors])
}


typealias HomeDelegate = HomePresnterDelegate & UIViewController

class HomePresnter:NSObject{
    
    weak var delegate:HomeDelegate?
    
    func getProviderData(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.getServiceProvider { status, data, message in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setProviderData(data: data)
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
