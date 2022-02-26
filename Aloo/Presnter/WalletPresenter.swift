//
//  Wallet.swift
//  Aloo
//
//  Created by macbook on 10/19/21.
//


import UIKit

protocol WalletPresenterDelegate {
    func showAlert(title:String,message:String)
    func walletDetails(data:UserWalletData)
    func cancelPackageSuccessAction()
}

typealias WalletDelegate = WalletPresenterDelegate & UIViewController



class WalletPresenter:NSObject{
    
    weak var delegate:WalletDelegate?
    
    func wallet(){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                ProfileApiControllers.shard.wallet { (status, message, data) in
                    if status{
                        if let data = data{
                            DispatchQueue.main.async {
                                self.delegate?.walletDetails(data: data)
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
    
    func cancelPackage(id:String){
        GeneralActions.shard.monitorNetwork {
            DispatchQueue.main.async {
                OrdersApiController.shard.cancelPackage(id: id) { status, message in
                    if status{
                        self.delegate?.cancelPackageSuccessAction()
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
