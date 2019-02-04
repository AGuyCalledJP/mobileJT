//
//  StartDateCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class StartDateCell: UITableViewCell {
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var sLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sLabel.text = "Starts"
    }
}
