//
//  FAQTableViewCell.swift
//  Aloo
//
//  Created by Hany Alkahlout on 29/09/2021.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        answerLabel.isHidden = true
        // Configure the view for the selected state
    }
    
    func setData(data:Items){
        questionLabel.text = data.question
        answerLabel.text = data.answer
    }

    
    @IBAction func showHideAction(_ sender: UIButton) {

    }
}
