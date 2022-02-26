//
//  NotificationPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 23/11/2021.
//

import UIKit

protocol NotificationPresnterDelegate{
    func showAlert(title:String,message:String)
    func notificationResponse(data:GetNotificationInfo)
}

typealias NotificationDelegate = NotificationPresnterDelegate & UIViewController

class NotificationPresnter : NSObject{
    
    weak var delegate:NotificationDelegate?
    
    
    func getNotificationData(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                ProfileApiControllers.shard.getNotification { status, message, data in
                    if status{
                        DispatchQueue.main.async {
                            if let data = data{
                                self.delegate?.notificationResponse(data: data)
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
    
    
}
