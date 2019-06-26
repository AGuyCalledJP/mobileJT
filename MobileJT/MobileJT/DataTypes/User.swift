//
//  File.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation

class User: Comparable {
    var fName : String?
    var lName : String?
    var height : Int?
    var weight : Int?
    var events : [Event]?
    var userName : String?
    var password : String?
    var email : String?
    var delegation : String?
    
    init?(_ fName: String, _ lName: String, _ height: Int?, _ weight: Int?, _ events: [Event], _ userName: String, _ password: String, _ email: String) {
        guard !fName.isEmpty && !lName.isEmpty && !userName.isEmpty && !password.isEmpty && !email.isEmpty else {
            return nil
        }
        guard let _ = height else {
            return nil
        }
        guard let _ = weight else {
            return nil
        }
        
        self.fName = fName
        self.lName = lName
        self.height = height
        self.weight = weight
        self.events = events
        self.userName = userName
        self.password = password
        self.email = email
        self.delegation = "user"
    }
    
    init?(_ fName: String, _ lName: String, _ height: Int?, _ weight: Int?, _ events: [Event], _ userName: String, _ password: String, _ email: String, _ delegation: String) {
        guard !fName.isEmpty && !lName.isEmpty && !userName.isEmpty && !password.isEmpty && !email.isEmpty else {
            return nil
        }
        guard let _ = height else {
            return nil
        }
        guard let _ = weight else {
            return nil
        }
        
        self.fName = fName
        self.lName = lName
        self.height = height
        self.weight = weight
        self.events = events
        self.userName = userName
        self.password = password
        self.email = email
        self.delegation = delegation
    }
    
    init?() {
        return nil
    }
    
    func setDelegation(_ delegation: String) {
        self.delegation = delegation
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.lName! < rhs.lName!
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.lName == rhs.lName
    }
}
