//
//  PackageTabelCellPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 04/12/2021.
//

import UIKit

protocol PackageTabelCellPresnterDelegate{
    func showAlert(title:String,message:String)
    func showCustomAlert(title:String,message:String)
    func showCustomeAlertWithUrl(title:String,message:String,link:String,stc:String)
}

typealias PackageTabelCellDelegate = PackageTabelCellPresnterDelegate & UITableViewCell

class PackageTabelCellPresnter : NSObject{
    
    weak var delegate:PackageTabelCellDelegate?
    
    func addPackage(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.addPackage(id: id) { status, message , url , stc in
                    if status{
                        self.delegate?.showCustomAlert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Package added successfully", comment: ""))
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showCustomeAlertWithUrl(title: NSLocalizedString("Error", comment: ""), message: message,link:url,stc:stc)
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
