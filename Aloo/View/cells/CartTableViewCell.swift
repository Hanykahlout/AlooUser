//
//  CartTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 26/09/2021.
//

import UIKit

protocol CartTableViewCellDelegate {
    func goToMealViewController(id:String)
    func deleteMealFromCart(id:String,indexPath:IndexPath)
}


class CartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var addtionsDetailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton : UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var delegate:CartTableViewCellDelegate?
    private var id = ""
    
    func setData(data:CartItems){
        countLabel.text = "\(NSLocalizedString("Count:", comment: "")) \(data.amount ?? 0)"
        editButton.isHidden = data.is_offer ?? true
        id = String(data.id!)
        mealImageView.sd_setImage(with: URL(string: data.item?.img ?? ""))
        mealNameLabel.text = data.item?.name ?? ""
        addtionsDetailsLabel.text = """
\(NSLocalizedString("Size", comment: "")): \(data.data?.size ?? "")
\(NSLocalizedString("With", comment: "")): \(data.data?.with?.joined(separator: ",") ?? "")
\(NSLocalizedString("Without", comment: "")): \(data.data?.without?.joined(separator: ",") ?? "")
\(NSLocalizedString("Drinks", comment: "")): \(getAllInDrinks(drinks:data.data?.drinks ?? []))
\(NSLocalizedString("Extras", comment: "")): \(getAllInDrinks(drinks:data.data?.extras ?? []))
"""
        priceLabel.text = data.total_price ?? ""
        
    }
    
    private func getAllInDrinks(drinks:[Drinks]) ->String{
        var result = ""
        for drink in drinks{
            result.append(",\(drink.name ?? "")")
        }
        return result
    }
    
    @IBAction func editAction(_ sender: Any) {
        delegate?.goToMealViewController(id:id)
    }
    
    @IBAction func trashAction(_ sender: Any) {
        self.delegate?.deleteMealFromCart(id: id,indexPath: self.currentIndexPath!)
    }
    
    
    
}
