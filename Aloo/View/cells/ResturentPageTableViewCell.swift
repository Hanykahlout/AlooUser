//
//  ResturentPageTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 25/09/2021.
//

import UIKit

class ResturentPageTableViewCell: UITableViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealDescriptionLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private let presnter = ResturentPageCellPresnter()
    private var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        presnter.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data:RestaurantItems){
        self.id = String(data.id ?? -1)
        mealImageView.sd_setImage(with: URL(string: data.img ?? ""))
        mealNameLabel.text = data.name ?? ""
        mealDescriptionLabel.text = data.description ?? ""
        numberOfCaloriesLabel.text = "\(data.calories ?? "") \(NSLocalizedString("calories", comment: ""))"
        print("price \(data.price)")
        priceLabel.text = "Price:S\(data.price ?? 0)"
        favButton.isSelected = data.is_favorite ?? false
    }
    
    
    @IBAction func favAction(_ sender: UIButton) {
        if sender.isSelected{
            presnter.deleteFavorite(id: id)
        }else{
            presnter.addFavorite(id: id)
        }
    }
    
    
}


extension ResturentPageTableViewCell:ResturentPageCellPresnterDelegate{
    
    func changeFavoriteButtonStatus(isSelected:Bool) {
        favButton.isSelected = isSelected
    }
    
}





