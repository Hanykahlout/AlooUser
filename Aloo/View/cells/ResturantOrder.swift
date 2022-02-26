//
//  ResturantOrder.swift
//  Aloo
//
//  Created by macbook on 9/29/21.
//

import UIKit

class ResturantOrder: UITableViewCell {
    
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if L102Language.currentAppleLanguage() == "ar"{
            arrowButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setData(data:ShowOrdersItems){
        placeImageView.sd_setImage(with: URL(string: data.vendor?.logo ?? ""))
        nameLabel.text = data.vendor?.name ?? ""
        timeLabel.text = data.date ?? ""
        orderNumberLabel.text = String(data.vendor?.id ?? 0)
        priceLabel.text = String(data.price ?? "")
        
    }
    
}


