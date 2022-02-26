//
//  DeliveryAddressesTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit

class DeliveryAddressesTableViewCell: UITableViewCell {
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var LocationDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Places){
        locationTitleLabel.text = data.name ?? ""
        LocationDescriptionLabel.text = data.location_name ?? ""
    }

}



