//
//  PaymentHandler.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 12/12/2021.
//

import Foundation
import PassKit

class PaymentHandler:NSObject{
    
    public static var shard: PaymentHandler = {
        let paymentHandler = PaymentHandler()
        return paymentHandler
    }()
    
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var completionHandler: ((Bool) -> Void)!
    
    private let supportedNetworks: [PKPaymentNetwork] = [
        .masterCard,
        .visa
    ]
    
    func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    
    func startPayment(price:String,completionHandler:@escaping (Bool)->Void){
        self.completionHandler = completionHandler
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: price), type: .final)
        paymentSummaryItems = [total]
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.com.prographyappco.aloo"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "SA"
        paymentRequest.currencyCode = "SAR"
        paymentRequest.shippingType = .delivery
        paymentRequest.supportedNetworks = supportedNetworks
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                completionHandler(true)
            } else {
                self.completionHandler(false)
            }
        })
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate{
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Perform basic validation on the provided contact information.
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        if payment.shippingContact?.postalAddress?.isoCountryCode != "SA" {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only available in the United States")
            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
        } else {
            print("Token:: \(payment.token.transactionIdentifier)")
            // Send the payment token to your server or payment provider to process here.
            // Once processed, return an appropriate status in the completion handler (success, failure, and so on).
            completion(PKPaymentAuthorizationResult.init(status: status, errors: errors))
        }
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
}


