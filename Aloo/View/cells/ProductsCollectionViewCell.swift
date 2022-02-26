//
//  ProductsCollectionViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    private var id = ""
    private let presnter = ProductsCellPresnter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presnter.delegate = self
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
    }
    
    @IBAction func favButtonAction(_ sender: UIButton) {
        if sender.isSelected{
            presnter.deleteFavorite(id: id)
        }else{
            presnter.addFavorite(id: id)
        }
    }
    
    
    func setData(data:FavouriteItems){
        id = String(data.id!)
        productImageView.sd_setImage(with: URL(string: data.img ?? ""))
        productTitleLabel.text = data.name ?? ""
        priceLabel.text = "\(data.price ?? 0) \(NSLocalizedString("SR", comment: ""))"
        weightLabel.text = "\(data.amount ?? 0) \(data.amount_type ?? "")"
        favButton.isSelected = data.is_favorite ?? false
    }
    
}


extension ProductsCollectionViewCell:ProductsCellPresnterDelegate{
    
    
    func changeFavoriteButtonStatus(isSelected:Bool) {
        favButton.isSelected = isSelected
    }
    
}
