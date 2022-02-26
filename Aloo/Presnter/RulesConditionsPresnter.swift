//
//  RulesConditionsPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 18/10/2021.
//

import UIKit

protocol RulesConditionsPresnterDelegate {
    func showAlert(title:String,message:String)
    func showPrivacyData(data:String)
}

typealias RulesConditionsDelegate = RulesConditionsPresnterDelegate & UIViewController

class RulesConditionsPresnter:NSObject{
    
    weak var delegate:RulesConditionsDelegate?
    
    func getPrivacyData(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.privacyPolicy { status, data in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.showPrivacyData(data: data.data ?? "")
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
