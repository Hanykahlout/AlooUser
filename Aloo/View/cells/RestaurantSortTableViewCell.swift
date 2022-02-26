//
//  RestaurantSortTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 24/09/2021.
//

import UIKit

class RestaurantSortTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var selectRadioButtonImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
