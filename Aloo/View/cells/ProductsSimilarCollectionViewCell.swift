//
//  ProductsSimilarCollectionViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 08/10/2021.
//

import UIKit

class ProductsSimilarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageViewCustomCornerRadius!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setData(data:Similar){
        productImageView.sd_setImage(with: URL(string: data.img ?? ""))
        productNameLabel.text = data.name ?? ""
        priceLabel.text = "\(data.price ?? "") \(NSLocalizedString("SR", comment: ""))"
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
    }
}
