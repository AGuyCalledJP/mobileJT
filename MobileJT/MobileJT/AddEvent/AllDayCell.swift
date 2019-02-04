//
//  AllDayCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class AllDayCell: UITableViewCell {
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.text = "All-day"
    }
}
