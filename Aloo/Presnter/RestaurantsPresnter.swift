//
//  RestaurantsPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 09/11/2021.
//

import UIKit

protocol RestaurantsPresnterDelegate {
    func showAlert(title:String,message:String)
    func vendorsData(data:ListVendorData)
    func setRestaurantTypes(data:[CitiesInfo])
    func setKitchenTypes(data:[CitiesInfo])
    func setPlaces(data:[Places])
}

typealias RestaurantsDelegate = RestaurantsPresnterDelegate & UIViewController

class RestaurantsPresnter:NSObject{
    
    weak var delegate:RestaurantsDelegate?
    
    func getListOfGuestVendors(vendorId:String,page:String,lon:String,lat:String,orderId:String,kitchenType:String,restaurantType:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.listGuestVendor(vendor_id: vendorId, page: page, lon: lon, lat: lat, orderId: orderId, kitchenType: kitchenType, restaurantType: restaurantType) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.vendorsData(data: data)
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
                self.delegate?.showAlert(title: "Error", message: "Internet Connection Error")
            }
        }
    }
    
    
    func getListOfUserVendors(vendorId:String,page:String,placeId:String,orderId:String,kitchenType:String,restaurantType:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                HomeApiController.shard.listUserVendor(vendor_id: vendorId, page: page, placeId: placeId, orderId: orderId, kitchenType: kitchenType, restaurantType: restaurantType) { status, message, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.vendorsData(data: data)
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
                self.delegate?.showAlert(title: "Error", message: "Internet Connection Error")
            }
        }
    }
    
    func getRestaurantTypes(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.getRestaurantTypes { status, message, data in
                    if status{
                        if let data = data , let types = data.restaurant_types{
                            DispatchQueue.main.async {
                                self.delegate?.setRestaurantTypes(data: types)
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
                self.delegate?.showAlert(title: "Error", message: "Internet Connection Error")
            }
        }
    }
    
    
    func getKitchenTypes(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.getKitchenTypes { status, message, data in
                    if status{
                        if let data = data , let types = data.kitchen_types{
                            DispatchQueue.main.async {
                                self.delegate?.setKitchenTypes(data: types)
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
    
    func getAddress(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                PlacesApiControllers.shard.getNewPlaces { status, data in
                    if status{
                        if let data = data{
                            self.delegate?.setPlaces(data: data.places ?? [])
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
