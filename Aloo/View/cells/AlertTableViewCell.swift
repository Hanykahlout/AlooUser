//
//  AlertTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 27/09/2021.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
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
    
    func setData(data:NotificationItems){
        titleLabel.text = data.title ?? ""
        descrptionLabel.text = data.body ?? ""
        timeLabel.text = "now"
        
    }
}
