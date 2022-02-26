//
//  ProfilePresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/10/2021.
//

import UIKit

protocol ProfilePresnterDelegate {
    func showAlert(title:String,message:String)
    func setUserData(data:UserDataResponseData)
    func goBackAction()
    func setCitiesData(data:CitiesBasedData)
}



typealias ProfileDelegate = ProfilePresnterDelegate & UIViewController

class ProfilePresnter:NSObject{
    
    weak var delegate:ProfileDelegate?
    
    
    func setUserData(user:UserData){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                ProfileApiControllers.shard.setUserData(user: user) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                            self.delegate?.goBackAction()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                        }
                    }
                }
            }
        } notConectedAction: {
            DispatchQueue.main.async {
                self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Success", comment: ""))
            }
        }
    }
    
    
    
    func getUserData(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                ProfileApiControllers.shard.getUserData { status, message ,data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setUserData(data: data)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                        }
                    }
                }
            }
        } notConectedAction: {
            DispatchQueue.main.async {
                self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Success", comment: ""))
            }
        }
    }
    
    func getCities(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.GetCities { data, status, message in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setCitiesData(data: data)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                                self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: message)
                        }
                    }
                }
            }
        } notConectedAction: {
            DispatchQueue.main.async {
                self.delegate?.showAlert(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Success", comment: ""))
            }
        }
    }
    
    func validation(name:String,phoneNumber:String,gender:String,region:String) -> Bool{
        return !name.isEmpty && !phoneNumber.isEmpty && !gender.isEmpty && !region.isEmpty
    }
    
}
