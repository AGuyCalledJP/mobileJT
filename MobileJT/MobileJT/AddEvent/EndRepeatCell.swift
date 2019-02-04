//
//  EndRepeatCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class EndRepeatCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var endRepeatDate: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.text = "End Repeat"
    }
}
