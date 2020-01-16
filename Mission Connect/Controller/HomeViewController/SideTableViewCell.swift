//
//  SideTableViewCell.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 1/14/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var subTitleLabel: UILabel!
     @IBOutlet weak var memberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
