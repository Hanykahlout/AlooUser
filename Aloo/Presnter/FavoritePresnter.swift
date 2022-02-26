//
//  FavoritePresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 09/11/2021.
//

import UIKit


protocol FavoritePresnterDelegate {
    func showAlert(title:String,message:String)
    func setVendorsList(data:GetFavouriteByTypeData)
    func setItems(data:GetFavouriteItemsData)
}

typealias FavoriteDelegate = FavoritePresnterDelegate & UIViewController

class FavoritePresnter:NSObject{
    
    weak var delegate:FavoriteDelegate?
    
    func getFavoriteVendors(type:String,page:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                FavouriteApiController.shard.getFavourite(vendorTypeNumber: type, page: page) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setVendorsList(data: data)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: "Error", message: message)
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
    
    func getFavoriteItems(id:String,page:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                FavouriteApiController.shard.getFavouriteItems(id: id, page: page) { status, message, data in
                    if status{
                        if let data = data{
                            self.delegate?.setItems(data: data)
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
