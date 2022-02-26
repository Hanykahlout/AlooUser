//
//  ResturantCollectionViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 23/09/2021.
//

import UIKit

class ResturantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFill
    }
    
}
