//
//  IncorpCalCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class IncorpCalCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.text = "Calendars?"
    }
}
