//
//  PackagePresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 01/12/2021.
//

import UIKit

protocol PackagePresnterDelegate{
    func setPackages(data:PackageData)
    func showAlert(title:String,message:String)
}

typealias PackageDelegate = PackagePresnterDelegate & UIViewController


class PackagePresnter:NSObject{
    
    weak var delegate:PackageDelegate?

    func getPackages(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.getPackages { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setPackages(data: data)
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




