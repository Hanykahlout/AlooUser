//
//  MealsAddtionsTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 25/09/2021.
//

import UIKit

class MealsAddtionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addtionNameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setData(data:OptionalsInfo){
        priceLabel.isHidden = true
        addtionNameLabel.text = data.option
        selectButton.isSelected = data.isSelected
    }
    
    func setData(data:Drinks){
        priceLabel.isHidden = false
        addtionNameLabel.text = data.name ?? ""
        priceLabel.text = "\(data.price ?? 0) \(NSLocalizedString("SR", comment: ""))"
        selectButton.isSelected = data.isSelected
    }
    
}
