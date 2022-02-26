//
//  MyAccountPageTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 27/09/2021.
//

import UIKit

protocol MyAccountPageCellDelegate{
    func showAlert(title:String,firstButtonText:String,secondButtonText:String)
}

class MyAccountPageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageSwitch: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeNumberLabel: UILabel!
    
     var delegate:MyAccountPageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:(image:UIImage,title:String,badge:Int,isLang:Bool,lang:String)){
        iconImageView.image = data.image
        titleLabel.text = data.title
        if data.badge != 0{
            badgeNumberLabel.isHidden = false
            badgeNumberLabel.text = String(data.badge)
        }else{
            badgeNumberLabel.isHidden = true
        }
        
        if data.isLang {
            languageSwitch.isHidden = false
            languageSwitch.isSelected = L102Language.currentAppleLanguage() == "ar"
        }else{
            languageSwitch.isHidden = true
        }
    }
    
    @IBAction func languageSwitchAction(_ sender: Any) {
        delegate!.showAlert(title: NSLocalizedString("The application will be restarted", comment: ""), firstButtonText: NSLocalizedString("Ok", comment: ""), secondButtonText: NSLocalizedString("I do not want", comment: ""))
    }

    
}
