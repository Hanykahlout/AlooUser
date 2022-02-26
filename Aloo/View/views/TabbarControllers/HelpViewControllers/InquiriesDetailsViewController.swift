//
//  InquiriesDetailsViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 19/10/2021.
//

import UIKit

class InquiriesDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var supportImageView: UIImageView!
    @IBOutlet weak var userReportLabel: UILabel!
    @IBOutlet weak var appResponseLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
