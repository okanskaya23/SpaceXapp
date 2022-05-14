//
//  CustomRocketCell.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 14.05.2022.
//

import UIKit

class CustomRocketCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    static let cellIdentifier = "CustomRocketCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "CustomRocketCell", bundle: nil)
    }
    
}
