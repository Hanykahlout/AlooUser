//
//  ProductDetailsPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/11/2021.
//

import UIKit

protocol ProductDetailsPresnterDelegate {
    func showAlert(title:String,message:String)
    func setData(data:SuperMarketVendorItem)
    func changeFavoriteButtonStatus(isSelected: Bool)
    func setEditingItemData(data:CartItems)
}


typealias ProductDetailsDelegate = ProductDetailsPresnterDelegate & UIViewController


class ProductDetailsPresnter:NSObject{
    
    weak var delegate:ProductDetailsDelegate?
    
    
    func getVendorItem(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.getSuperMarketItem(id: id) { status, message, data in
                    if status{
                        if let data = data {
                            DispatchQueue.main.async {
                                self.delegate?.setData(data: data)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title:  NSLocalizedString("Error", comment: ""), message: message)
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
    
    func addFavorite(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                FavouriteApiController.shard.addFavourite(id: id) { status, message, data in
                    if status {
                        DispatchQueue.main.async {
                            self.delegate?.changeFavoriteButtonStatus(isSelected: true)
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
    
    
    func deleteFavorite(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                FavouriteApiController.shard.deleteFavouriteItem(id: id) { status, message in
                    if status {
                        DispatchQueue.main.async {
                            self.delegate?.changeFavoriteButtonStatus(isSelected: false)
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
    
    func addToCart(itemId:String,amount:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.addToCartInSupermarket(itemId: itemId, amount: amount) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Successfully Added To Cart", comment: ""), message: "")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title:  NSLocalizedString("Error", comment: ""), message: message)
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
                            self.delegate?.showAlert(title:  NSLocalizedString("Error", comment: ""), message: message)
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
    
    
    func editItem(id:String,amount:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                CartApiController.shard.editSuperMarketCartItem(amount: amount, id: id) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Successfully Updated", comment: ""), message: "")
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


