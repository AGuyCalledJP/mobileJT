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
    var month:Int
    var monthName:String
    var daysInMonth:Int
    var days:[Day]
    var year:Int
    
    let months = ["January","February","March","April","May","June",
                  "July","August","September","October","November", "December"]
    
    let numDays = [31,28,31,30,31,30,31,31,30,31,30,31,29]
    
    let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let calcMVals = [11,12,1,2,3,4,5,6,7,8,9,10]
    
    init?(_ month:Int, _ year:Int) {
        //Set some values
        self.month = month
        self.monthName = months[month]
        self.daysInMonth = numDays[month]
        self.year = year
        //Find first day
        let k = 0
        let m = calcMVals[month]
        var y = year
        if (m == 11 || m == 12) {
            y = year - 1
        }
        let hold = Array(String(y))
        let one = String(hold[0])
        let two = String(hold[1])
        let three = String(hold[2])
        let four = String(hold[3])
        let A = one + two
        let B = three + four
        let C = Int(A)!
        let D = Int(B)!
        let f1 = k + ((13 * m - 1) / 5)
        let f2 =  D + (D/4) + (C/4) - (2 * C)
        let f = f1 + f2
        var day = 0
        if (f > 0) {
            day = f % 7
        }
        else {
            day = ((f % 7) + 7) % 7
        }
        print(day)
        var days = [Day]()
        //Fill calendar
        for numDays in 0...numDays[month] - 1 {
            var events = [Event?]()
            let e = Event("Holder", 9, 12, true, "Thompson", month, day)
            events.append(e)
            let d = Day(numDays + 1, dayNames[day], events, monthName)
            if (day < 6) {
                day += 1
            }
            else {
                day = 0
            }
            days.append(d!)
        }
        self.days = days
    }
    
    init?() {
        self.month = 0
        self.monthName = ""
        self.daysInMonth = 0
        self.year = 0
        self.days = [Day]()
    }
    
    func prevMonth() -> String {
        if month > 0 {
            return months[month-1]
        }
        else {
            return months[11]
        }
    }
    
    func nextMonth() -> String {
        if month < 11 {
            return months[month+1]
        }
        else {
            return months[0]
        }
    }
}
