//
//  CartPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 15/11/2021.
//

import UIKit

protocol CartPresnterDelegate {
    func showAlert(title:String,message:String)
    func showSuccessAlert(title:String,message:String)
    func cartData(data:CartDataReponse)
    func deleteMealFromTableView(indexPath:IndexPath)
    func showCustomAlert(title:String,message:String,link:String,stc:String)
}



typealias CartDelegate = CartPresnterDelegate & UIViewController

class CartPresnter:NSObject{
    
    weak var delegate:CartDelegate?
    
    
    func getCartData(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.GetAllCart(id: id) { status, data, message in
                    if status{
                        if let data = data{
                            self.delegate?.cartData(data: data)
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
    
    
    func deleteItem(id:String,indexPath:IndexPath){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.deleteFromCart(id: id) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.deleteMealFromTableView(indexPath: indexPath)
                            self.delegate?.showAlert(title: NSLocalizedString("Meal Successfully Deleted", comment: ""), message: "")
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
    
    
    func submitCart(placeId:String,supportedVendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.submitCart(supportedVendorId: supportedVendorId, placeId: placeId) { status, message , url ,stc in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showSuccessAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showCustomAlert(title: NSLocalizedString("Error", comment: ""), message: message, link: url, stc: stc)
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

