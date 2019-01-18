//
//  AddEventTableViewCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/17/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import MultiSelectSegmentedControl

class AddEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatPicker: MultiSelectSegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
