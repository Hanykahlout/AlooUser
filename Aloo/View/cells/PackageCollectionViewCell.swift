//
//  PackageCollectionViewCell.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 01/12/2021.
//

import UIKit

protocol PackageCollectionViewCellDelegate{
    func showCustomAlert(title:String,message:String)
    func showAlert(title:String,message:String)
}

class PackageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var packageNumberLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var numberOfMonthlyOrdersLabel: UILabel!
    
    @IBOutlet weak var discountCouponLabel: UILabel!
    
    @IBOutlet weak var packageDurationLabel: UILabel!
    
    @IBOutlet weak var requestPackageButton: UIButton!
    
    public var delegate:PackageCollectionViewCellDelegate?
    private let presnter = PackageCellPresnter()
    private var id:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        presnter.delegate = self
        // Initialization code
    }
    
    func setData(data:Packages){
        id = String(data.id ?? -1)
        packageNumberLabel.text = "\(NSLocalizedString("Aloo", comment: "")) \(data.id ?? -1)"
        priceLabel.text = "\(data.price ?? "") \(NSLocalizedString("SR", comment: ""))"
        numberOfMonthlyOrdersLabel.text = "\(NSLocalizedString("Number Of Monthly Orders:", comment: "")) \(data.orders ?? "") \(NSLocalizedString("Orders", comment: ""))"
        discountCouponLabel.text = "\(NSLocalizedString("Discount Coupon:", comment: "")) \(data.discount ?? "")"
        packageDurationLabel.text = "\(NSLocalizedString("Package Duration:", comment: "")) \(data.days ?? "") \(NSLocalizedString("day", comment: ""))"
    }
    
    @IBAction func requestPackageAction(_ sender: Any) {
        presnter.addPackage(id: id)
    }
    
}


extension PackageCollectionViewCell:PackageCellPresnterDelegate{
    
    func showCustomAlert(title: String, message: String) {
        delegate?.showCustomAlert(title: title, message: message)
    }
    
    func showAlert(title: String, message: String) {
        delegate?.showAlert(title: title, message: message)
    }
    
}
