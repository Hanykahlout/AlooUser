//
//  AboutAppPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 18/10/2021.
//

import UIKit


protocol AboutAppPresnterDelegate {
    func showAlert(title:String,message:String)
    func setAboutData(data:AboutData)
}

typealias AboutAppDelegate = AboutAppPresnterDelegate & UIViewController


class AboutAppPresnter : NSObject{
    
    weak var delegate:AboutAppDelegate?
    
    func getAboutData(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.GetAbout { status, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.setAboutData(data: data)
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
    
}

