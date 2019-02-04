//
//  EndDateCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class EndDateCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var endDate: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.text = "Ends"
    }
}
