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
    var startTime: Int
    var dispStart: String
    var endTime: Int
    var dispEnd: String
    var ongoing: Bool
    var location: String
    var month: Int
    var year: Int
    var day: Int
    
    struct PropertyKey {
        static let name = "name"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let ongoing = "ongoing"
        static let location = "location"
        static let month = "month"
        static let year = "year"
        static let day = "day"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    
    init?(_ name: String,_ startTime: Int,_ endTime: Int,_ ongoing: Bool,_ location: String,_ month:Int,_ year:Int, _ day:Int) {
        guard !name.isEmpty else {
            return nil
        }
        
        guard startTime >= 0 && startTime <= 24 else{
            return nil
        }
        
        guard endTime >= 0 && endTime <= 24 else{
            return nil
        }
        
        guard startTime < endTime else{
            return nil
        }
        
        guard !location.isEmpty else {
            return nil
        }
        
        self.name = name
        self.startTime = startTime
        self.dispStart = String(startTime)
        self.endTime = endTime
        self.dispEnd = String(endTime)
        self.ongoing = ongoing
        self.location = location
        if ongoing {
            self.month = -1
            self.year = -1
        }
        else {
            self.month = month
            self.year = year
        }
        self.day = day
    }
    
    init?(_ name:String) {
        if !name.isEmpty {
            self.name = name
            self.startTime = 0
            self.dispStart = ""
            self.endTime = 1
            self.dispEnd = ""
            self.ongoing = false
            self.location = ""
            self.month = -1
            self.year = -1
            self.day = 0
        }
        else {
            return nil
        }
        
    }
    
    //Encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(startTime, forKey: PropertyKey.startTime)
        aCoder.encode(endTime, forKey: PropertyKey.endTime)
        aCoder.encode(ongoing, forKey: PropertyKey.ongoing)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(month, forKey: PropertyKey.month)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(day, forKey: PropertyKey.day)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let startTime = aDecoder.decodeInteger(forKey: PropertyKey.startTime)
        let endTime = aDecoder.decodeInteger(forKey: PropertyKey.endTime)
        let ongoing = aDecoder.decodeBool(forKey: PropertyKey.ongoing)
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let month = aDecoder.decodeInteger(forKey: PropertyKey.month)
        let year = aDecoder.decodeInteger(forKey: PropertyKey.year)
        let day = aDecoder.decodeInteger(forKey: PropertyKey.day)


        
        // Must call designated initializer.
        self.init(name, startTime, endTime, ongoing, location!, month, year, day)
    }
}
