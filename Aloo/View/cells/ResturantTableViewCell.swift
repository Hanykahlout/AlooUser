//
//  ResturantTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 23/09/2021.
//

import UIKit
import Cosmos
class ResturantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background_View: UIView!
    @IBOutlet weak var resturentImageView: UIImageView!
    @IBOutlet weak var resturentNameLable: UILabel!
    @IBOutlet weak var resturentTypeLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background_View.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:ListVendorItems){
        resturentImageView.sd_setImage(with: URL(string: data.logo ?? ""))
        resturentNameLable.text = data.name ?? ""
        resturentTypeLabel.text = data.description ?? ""
        minPriceLabel.text = data.min_price ?? ""
        ratingView.rating = Double(data.rates?.number ?? 0)
        
    }
    
    
}






