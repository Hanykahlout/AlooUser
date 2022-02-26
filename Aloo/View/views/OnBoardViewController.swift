//
//  OnBoardViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 22/09/2021.
//

import UIKit

class OnBoardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func startAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        navigationController?.pushViewController(LoginUserViewController(), animated: true)
    
    }
    
    
}



