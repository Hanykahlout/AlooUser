//
//  QuestionViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 19/10/2021.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    public var type:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        if !questionTextView.text!.isEmpty{
            DataApiControllers.shard.customerClientService(type: type, question: questionTextView.text!) { status, message in
                if status{
                    DispatchQueue.main.async {
                        GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Sent Succesfully", comment: ""))
                    }
                }else{
                    DispatchQueue.main.async {
                        GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: message)
                    }
                }
            }
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is Empty Fields!!", comment: ""))
        }
    }
    
    
    
}
