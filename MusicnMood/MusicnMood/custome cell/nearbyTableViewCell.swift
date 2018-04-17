//
//  nearbyTableViewCell.swift
//  MusicnMood
//
//  Created by WJL on 4/11/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit

class nearbyTableViewCell: UITableViewCell {
    @IBOutlet weak var userpic: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usersong: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
