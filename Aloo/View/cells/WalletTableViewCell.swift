//
//  WalletTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var transferNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Wallet_details){
        timeLabel.text = data.date ?? ""
        transferNumberLabel.text = String(data.id ?? 0)
        titleLabel.text = data.message ?? ""
        subtitleLabel.text = data.order_type ?? ""
        reasonLabel.text = data.reason
        priceLabel.text = "\(String(describing: data.price ?? 0.0)) \(NSLocalizedString("SR", comment: ""))"
    }
    
}
