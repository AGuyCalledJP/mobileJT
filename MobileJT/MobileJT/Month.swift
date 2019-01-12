//
//  Month.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/12/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit

class Month {
    var monthName:String
    var daysInMonth:Int
    var days:[Day]
    
    let months = ["January","February","March","April","May","June","July","August","September","October","November", "December"]
    
    let numDays = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    init?(_ month: Int) {
        self.monthName = months[month]
        self.daysInMonth = numDays[month]
        var days = [Day]()
        for day in 0...numDays[month] - 1 {
            let dV = day % 7
            var events = [Event?]()
            let e = Event("Holder", 9, 12, true, "Thompson")
            events.append(e)
            let d = Day(day + 1, dayNames[dV], events, monthName)
            days.append(d!)
        }
        self.days = days
    }
    
    init?() {
        self.monthName = ""
        self.daysInMonth = 0
        self.days = [Day]()
    }
}
