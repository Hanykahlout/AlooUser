//
//  OrderSummaryTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 09/10/2021.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:OrderItems){
        productImageView.sd_setImage(with: URL(string: data.item?.img ?? ""))
        productNameLabel.text = data.item?.name ?? ""
        weightLabel.text = String(data.amount ?? 0)
        countLabel.text = String(data.id ?? -1)
        priceLabel.text = String(data.item_price ?? 0.0)
        
    }
    
}
