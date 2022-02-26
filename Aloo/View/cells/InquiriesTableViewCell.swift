//
//  AlertTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 27/09/2021.
//

import UIKit

class InquiriesTableViewCell: UITableViewCell {

    @IBOutlet weak var supportImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:(isSuppotImageHidden:Bool,supportImage:UIImage,icon:UIImage,title:String,description:String)){
        supportImageView.isHidden = data.isSuppotImageHidden
        supportImageView.image = data.supportImage
        iconImageView.image = data.icon
        titleLabel.text = data.title
        descrptionLabel.text = data.description

    }
    
    
}
