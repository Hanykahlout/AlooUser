//
//  ResturentPagePresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 10/11/2021.
//

import UIKit


protocol ResturentPagePresnterDelegate {
    func showAlert(title:String,message:String)
    func setCategories(categries:[Categories])
    func setListVendorItems(data:[RestaurantItems])
    func setListOfOffers(data:[RestaurantOffers])
    func setListSupermarketItems(data:[FavouriteItems])
}

typealias ResturentPageDelegate = ResturentPagePresnterDelegate & UIViewController

class ResturentPagePresnter: NSObject {
    
    weak var delegate:ResturentPageDelegate?
    
    
    func getCategories(vendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.getCategories(id: vendorId) { status, data in
                    if status{
                        if let data = data,let categories = data.categories{
                            DispatchQueue.main.async {
                                self.delegate?.setCategories(categries: categories)
                            }
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
    
    
    func getListVendorItems(page:String,orderBy:String,category:String,vendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.listVendorItem(page: page, order_by: orderBy, category: category, vendor_id: vendorId) { status, data, message in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setListVendorItems(data: data.main?.items ?? [])
                                self.delegate?.setListOfOffers(data: data.offers ?? [])
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
    
    
    func getListSupermarktsItems(page:String,orderBy:String,category:String,vendorId:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.listVendorSupermarketItem(page: page, order_by: orderBy, category: category, vendor_id: vendorId) { status, data, message in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setListSupermarketItems(data: data.items ?? [])
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



