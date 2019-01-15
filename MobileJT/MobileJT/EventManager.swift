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
    
    init?(_ oneOff:[Event?],_ repeating:[Event?]) {
        self.oneOff = oneOff
        self.repeating = repeating
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
}
