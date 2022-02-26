//
//  PackageCellPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 04/12/2021.
//

import UIKit

protocol PackageCellPresnterDelegate{
    func showAlert(title:String,message:String)
    func showCustomAlert(title:String,message:String)
}

typealias PackageCellDelegate = PackageCellPresnterDelegate & UICollectionViewCell

class PackageCellPresnter:NSObject{
    
    weak var delegate:PackageCellDelegate?
    
    
    func addPackage(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.addPackage(id: id) { status, message , url , stc in
                    if status{
                        self.delegate?.showCustomAlert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Package added successfully", comment: ""))
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

