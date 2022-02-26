//
//  MealDetailsPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 10/11/2021.
//

import UIKit

protocol MealDetailsPresnterDelegate {
    func showAlert(title:String,message:String)
    func setResponseData(data:FavouriteItems)
    func setEditingItemData(data:CartItems)
}

typealias MealDetailsDelegate = MealDetailsPresnterDelegate & UIViewController


class MealDetailsPresnter:NSObject{
    weak var delegate:MealDetailsDelegate?
    
    func getItem(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.getItem(itemId: id) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setResponseData(data: data)
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
    
    func addToCart(itemId:String,amount:String,with:[String],without:[String],size:String,drinks:[Int],extras:[Int]){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.addToCartInResturants(itemId: itemId, amount: amount, with: with, without: without, size: size, drinks: drinks, extras: extras) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Sucessfully Added To Cart", comment: ""), message: "")
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
    
    func getItemForEdit(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.getCartItemData(id: id) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setEditingItemData(data: data)
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
    
    
    func editItem(id:String,amount:String,size:String,with:[String],without:[String],drinks:[Int],extras:[Int]){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.editRestaurantCartItem(amount: amount, with: with, without: without, size: size, drinks: drinks, extras: extras, id: id) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Sucessfully Updated", comment: ""), message: "")
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
    
    func getOffer(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.getOffer(offerId: id) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setResponseData(data: data)
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


