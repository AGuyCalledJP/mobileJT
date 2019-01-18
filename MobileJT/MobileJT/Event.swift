//
//  Event.swift
//  MobileJT
//
//  Created by Jared Polonitza on 12/19/18.
//  Copyright © 2018 Jared Polonitza. All rights reserved.
//

import UIKit
import os.log

class Event: NSObject, NSCoding {
    var name: String
    var ongoing: [Int]
    var location: String
    var startTimeH: Int
    var endTimeH: Int
    var minS: Int
    var minE: Int
    var monthS: Int
    var monthE: Int
    var yearS: Int
    var yearE: Int
    var dayS: Int
    var dayE: Int
    
    struct PropertyKey {
        static let name = "name"
        static let ongoing = "ongoing"
        static let location = "location"
        static let startTimeH = "startTimeH"
        static let endTimeH = "endTimeH"
        static let minS = "minS"
        static let minE = "minE"
        static let monthS = "monthS"
        static let monthE = "monthE"
        static let yearS = "yearS"
        static let yearE = "yearE"
        static let dayS = "dayS"
        static let dayE = "dayE"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    
    init?(_ name: String,_ ongoing:[Int],_ location:String,_ yearS:Int,_ yearE:Int,_ monthS:Int,_ monthE:Int,_ dayS:Int,_ dayE:Int,_ startTimeH:Int,_ endTimeH:Int,_ minS:Int,_ minE:Int) {
        guard !name.isEmpty else {
            return nil
        }
        
        guard dayS <= dayE else {
            return nil
        }
        
        guard monthS <= monthE else {
            return nil
        }
        
        guard yearS <= yearE else {
            return nil
        }
        
        guard !location.isEmpty else {
            return nil
        }
        
        self.name = name
        self.ongoing = ongoing
        self.location = location
        self.startTimeH = startTimeH
        self.endTimeH = endTimeH
        self.minS = minS
        self.minE = minE
        self.monthS = monthS
        self.monthE = monthE
        self.yearS = yearS
        self.yearE = yearE
        self.dayS = dayS
        self.dayE = dayE
    }
    
    //Encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(ongoing, forKey: PropertyKey.ongoing)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(startTimeH, forKey: PropertyKey.startTimeH)
        aCoder.encode(endTimeH, forKey: PropertyKey.endTimeH)
        aCoder.encode(monthS, forKey: PropertyKey.monthS)
        aCoder.encode(monthE, forKey: PropertyKey.monthE)
        aCoder.encode(yearS, forKey: PropertyKey.yearS)
        aCoder.encode(yearE, forKey: PropertyKey.yearE)
        aCoder.encode(dayS, forKey: PropertyKey.dayS)
        aCoder.encode(dayE, forKey: PropertyKey.dayE)
        aCoder.encode(minS, forKey: PropertyKey.minS)
        aCoder.encode(minE, forKey: PropertyKey.minE)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let startTimeH = aDecoder.decodeInteger(forKey: PropertyKey.startTimeH)
        let endTimeH = aDecoder.decodeInteger(forKey: PropertyKey.endTimeH)
        let ongoing = aDecoder.decodeObject(forKey: PropertyKey.ongoing) as? [Int]
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let monthS = aDecoder.decodeInteger(forKey: PropertyKey.monthS)
        let monthE = aDecoder.decodeInteger(forKey: PropertyKey.monthE)
        let yearS = aDecoder.decodeInteger(forKey: PropertyKey.yearS)
        let yearE = aDecoder.decodeInteger(forKey: PropertyKey.yearE)
        let dayS = aDecoder.decodeInteger(forKey: PropertyKey.dayS)
        let dayE = aDecoder.decodeInteger(forKey: PropertyKey.dayE)
        let minS = aDecoder.decodeInteger(forKey: PropertyKey.minS)
        let minE = aDecoder.decodeInteger(forKey: PropertyKey.minE)


        
        // Must call designated initializer.
        self.init(name, ongoing!, location!, yearS, yearE, monthS, monthE, dayS, dayE, startTimeH, endTimeH, minS, minE)
    }
}
