//
//  PharmacyCartTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 08/10/2021.
//

import UIKit

protocol PharmacyCartTableViewCellDelegate {
    func goToEditProduct(id:String)
    func deleteMealFromCart(id:String,indexPath:IndexPath)
}

class PharmacyCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var delegate:PharmacyCartTableViewCellDelegate?
    private var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(data:CartItems){
        id = String(data.id ?? -1)
        editButton.isHidden = data.is_offer ?? false
        productImageView.sd_setImage(with: URL(string: data.item?.img ?? ""))
        productNameLabel.text = data.item?.name ?? ""
        weightLabel.text = "\(data.item?.calories ?? "") \(NSLocalizedString("calories", comment: ""))"
        priceLabel.text = data.total_price ?? ""
        
    }
    
    
    
    @IBAction func trachAction(_ sender: Any) {
        delegate?.deleteMealFromCart(id: id,indexPath: self.currentIndexPath!)
    }
    
    @IBAction func editAction(_ sender: Any) {
        delegate?.goToEditProduct(id: id)
    }
    
    
}


extension UIResponder {
    
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}


extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }
    
    var currentIndexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
