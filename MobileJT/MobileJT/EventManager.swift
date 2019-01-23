//
//  EventManager.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/14/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation

class EventManager {
    var oneOff: [Event?]
    var repeating: [Event?]
    
    init?(_ events:[Event?]) {
        oneOff = [Event?]()
        repeating = [Event?]()
        for e in events {
            if (e?.ongoing.isEmpty)! {
                oneOff.append(e)
            }
            else {
                repeating.append(e)
            }
        }
    }
    
    func addSingle(_ event:Event) {
        oneOff.append(event)
    }
    
    func addRepeating(_ event:Event) {
        repeating.append(event)
    }
    
    func getSingle() -> [Event?] {
        return oneOff
    }
    
    func getRepeating() -> [Event?] {
        return repeating
    }
    
    func getSingleMonth(_ month:Int) -> [Event?] {
        if !oneOff.isEmpty {
            var hold = [Event?]()
            for i in oneOff {
                if (i?.monthS)! <= month && (i?.monthE)! >= month {
                    hold.append(i)
                }
            }
            return hold
        }
        else {
            return [Event?]()
        }
    }
    
    func getRepeatingMonth(_ month:Int) -> [Event?] {
        if !repeating.isEmpty {
            var hold = [Event?]()
            for i in repeating {
                if (i?.monthS)! <= month || (i?.monthE)! >= month {
                    hold.append(i)
                }
            }
            return hold
        }
        else {
            return [Event?]()
        }
    }
    
    func managerIsEmpty() -> Bool {
        return oneOff.isEmpty && repeating.isEmpty
    }
}
