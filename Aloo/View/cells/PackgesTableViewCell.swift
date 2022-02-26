
//
//  PackgesTableViewCell.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 04/12/2021.
//

import UIKit

protocol PackgesTableViewCellDelegate{
    func showAlert(title:String,message:String)
    func showCustomAlert(title:String,message:String)
    func showCustomeAlertWithUrl(price:String,title: String, message: String,link:String,stc:String)
}

class PackgesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfOrdersLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    private var packagePrice = ""
    public var delegate:PackgesTableViewCellDelegate?
    private var presnter = PackageTabelCellPresnter()
    private var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presnter.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(data:Packages){
        id = String(data.id ?? -1)
        idLabel.text = "\(NSLocalizedString("Aloo", comment: "")) \(data.id ?? -1)"
        packagePrice = data.price ?? ""
        priceLabel.text = "\(data.price ?? "") \(NSLocalizedString("SR", comment: ""))"
        numberOfOrdersLabel.text = "\(NSLocalizedString("Number Of Monthly Orders:", comment: "")) \(data.orders ?? "") \(NSLocalizedString("Orders", comment: ""))"
        discountLabel.text = "\(NSLocalizedString("Discount Coupon:", comment: "")) \(data.discount ?? "")"
        durationLabel.text = "\(NSLocalizedString("Package Duration:", comment: "")) \(data.days ?? "") \(NSLocalizedString("day", comment: ""))"
    }
    
    @IBAction func requestPackageAction(_ sender: Any) {
        presnter.addPackage(id: id)
    }
    
}

extension PackgesTableViewCell: PackageTabelCellPresnterDelegate{
    func showCustomeAlertWithUrl(title: String, message: String,link:String,stc:String) {
        delegate?.showCustomeAlertWithUrl(price:packagePrice,title: title, message: message,link: link,stc:stc)
    }
    
    func showAlert(title: String, message: String) {
        delegate?.showAlert(title: title, message: message)
    }
    
    func showCustomAlert(title: String, message: String) {
        delegate?.showCustomAlert(title: title, message: message)
    }
    
}


