//
//  MyOrderTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 09/10/2021.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderPlcaceImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(image:UIImage,title:String){
        orderPlcaceImageView.image = image
        placeNameLabel.text = title
    }
    
}
