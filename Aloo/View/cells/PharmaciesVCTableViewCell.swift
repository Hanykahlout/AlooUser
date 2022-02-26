//
//  PharmaciesVCTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 07/10/2021.
//

import UIKit

class PharmaciesVCTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var BGImageView: UIImageView!
    
    
    func setData(data:ListVendorItems){
        headerImageView.sd_setImage(with: URL(string: data.logo ?? ""))
        BGImageView.sd_setImage(with: URL(string: data.image ?? ""))
    }
    
}
