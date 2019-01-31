//
//  FreeHourTableViewCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/30/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class FreeHourTableViewCell: UITableViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
