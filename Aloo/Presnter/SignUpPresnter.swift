//
//  SignUpPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/10/2021.
//

import UIKit


protocol SignUpPresnterDelegate {
    func showAlert(title:String,message:String)
    func goToPhoneVerifcation()
    func setCitiesData(data:CitiesBasedData)
}

typealias SignUpDelegate = SignUpPresnterDelegate & UIViewController

class SignUpPresnter:NSObject{
    
    weak var delegate:SignUpDelegate?
    
    
    func SignUp(user:User){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                AuthApiControllers.shard.signUp(user: user) { status, message in
                    if status{
                        DispatchQueue.main.async {
                            self.delegate?.goToPhoneVerifcation()
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
    
    
    func validation(name:String,phoneNumber:String,password:String,confirmPassword:String,gender:String,region:String ) -> Bool{
        return !name.isEmpty && !phoneNumber.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !gender.isEmpty && !region.isEmpty
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
