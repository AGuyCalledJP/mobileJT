//
//  Day.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/7/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Day: NSObject, NSCoding {
    var dayNum: Int
    var dayInWeek: String
    var events = [Event?]()
    var month: String
    
    struct PropertyKey {
        static let dayNum = "dayNum"
        static let dayInWeek = "dayInWeek"
        static let events = "events"
        static let month = "month"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    
    init?(_ dayNum: Int,_ dayInWeek:String,_ events: [Event?], _ month: String) {
        guard dayNum > 0 else {
            return nil
        }
        guard !dayInWeek.isEmpty else {
            return nil
        }
        
        self.dayNum = dayNum
        self.dayInWeek = dayInWeek
        self.events = events
        self.month = month
    }
    
    //Encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dayNum, forKey: PropertyKey.dayNum)
        aCoder.encode(dayInWeek, forKey: PropertyKey.dayInWeek)
        aCoder.encode(events, forKey: PropertyKey.events)
        aCoder.encode(month, forKey: PropertyKey.month)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let dayNum = aDecoder.decodeObject(forKey: PropertyKey.dayNum) as? Int else {
            os_log("Unable to decode the name for a day object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let dayInWeek = aDecoder.decodeObject(forKey: PropertyKey.dayInWeek) as? String
        
        let events = aDecoder.decodeObject(forKey: PropertyKey.events) as? [Event?]
        
        let month = aDecoder.decodeObject(forKey: PropertyKey.month) as? String
        
        // Must call designated initializer.
        self.init(dayNum, dayInWeek!, events!, month!)
    }
}
