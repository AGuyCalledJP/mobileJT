//
//  ClassListingTableViewCell.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/26/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit

class ClassListingTableViewCell: UITableViewCell {

    @IBOutlet weak var CourseTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
