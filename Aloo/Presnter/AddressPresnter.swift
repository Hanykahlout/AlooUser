//
//  AddressPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 14/10/2021.
//

import UIKit
import CoreLocation

protocol AddressPresnterDelegate {
    func showAlert(title:String,message:String)
    func setAllAddress(data:UserPlacesData)
    func reloadAddress()
    func removePlace()
}

typealias AddressDelegate = AddressPresnterDelegate & UIViewController

class AddressPresnter: NSObject {
    
    weak var delegate:AddressDelegate?
    
    
    func deleteAddress(id:String){
        
    }
    
    func getAddress(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                PlacesApiControllers.shard.getNewPlaces { status, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setAllAddress(data: data)
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
    
    
    func addNewPlaces(name:String,location_name:String,location:CLLocationCoordinate2D){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                PlacesApiControllers.shard.addNewPlaces(lon: location.longitude.description, lat: location.latitude.description, name: name,location_name: location_name) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.getAddress()
                            self.delegate?.reloadAddress()
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
    
    
    func deletePlace(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                PlacesApiControllers.shard.deletePlaces(id: id) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.removePlace()
                            self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: message)
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


