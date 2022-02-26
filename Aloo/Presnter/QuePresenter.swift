//
//  QuePresenter.swift
//  Aloo
//
//  Created by macbook on 10/19/21.
//

import Foundation
import UIKit

protocol QuePresenterDelegate {
    func showAlert(title:String,message:String)
    func QuestionItem(data:[Items])
}

typealias quedelegate = QuePresenterDelegate & UIViewController



class QuePresenter:NSObject{
    
    weak var delegate:quedelegate?
    
    func FrequentlyQuestion(){
        
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                DataApiControllers.shard.frequentlyQue { (status, items, msg) in
                    
                    if status{
                        if let questionItem = items{
                            
                            DispatchQueue.main.async {
                                self.delegate?.QuestionItem(data: questionItem)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: "Error", message: msg)
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
