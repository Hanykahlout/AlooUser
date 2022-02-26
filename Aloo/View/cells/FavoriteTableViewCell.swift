//
//  FavoriteTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:FavouriteItems){
        contentImageView.sd_setImage(with: URL(string: data.img ?? ""))
        nameLabel.text = data.name ?? ""
        caloriesLabel.text = "\(data.calories ?? "") \(NSLocalizedString("calories", comment: ""))"
        priceLabel.text = "\(data.price ?? 0) \(NSLocalizedString("SR", comment: ""))"
    }
    
    
}



