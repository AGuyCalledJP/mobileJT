//
//  AdminSettingsTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/26/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import MongoSwift
import SideMenu

class AdminSettingsTableViewController: UITableViewController {

    var team = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTeam()
        team.sort()
    }
    
    private func makeTeam() {
        let collection = try? LoginViewController.db?.collection("Users")
        do {
            let document = try collection?!.find()
            while let doc = document!.next() {
                print("I got one!")
                let grab = doc["_id"] as! ObjectId
                let fName = doc["fName"] as! String
                let lName = doc["lName"] as! String
                let height = doc["Height"] as! Int
                let weight = doc["Weight"] as! Int
                let email = doc["Email"] as! String
                let username = doc["Username"] as! String
                let password = doc["Password"] as! String
                let delegation = doc["Delegation"] as! String
                let events = getEvents(grab)
                let user = User(fName, lName, Int(height), Int(weight), events, username, password, email, delegation)
                team.append(user!)
            }
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
    }
    
    private func getEvents(_ uid: ObjectId) -> [Event] {
        var events = [Event]()
        let collection = try? LoginViewController.db?.collection("Events")
        let query : Document = ["UserId": uid]
        do {
            let document = try collection?!.find(query)
            for d in document! {
                let id = d["_id"] as! ObjectId
                let name = d["Name"] as! String
                let location = d["Location"] as! String
                let startTimeH = d["StartTimeH"] as! Int
                let endTimeH = d["EndTimeH"] as! Int
                let minS = d["MinS"] as! Int
                let minE = d["MinE"] as! Int
                let monthS = d["MonthS"] as! Int
                let monthE = d["MonthE"] as! Int
                let yearS = d["YearS"] as! Int
                let yearE = d["YearE"] as! Int
                let dayS = d["DayS"] as! Int
                let dayE = d["DayE"] as! Int
                //Update in the future
                let ongoing = makeOngoing(id)
                let e = Event(name, ongoing, location, Int(yearS), Int(yearE), Int(monthS), Int(monthE), Int(dayS), Int(dayE), Int(startTimeH), Int(endTimeH), Int(minS), Int(minE))
                events.append(e!)
            }
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        return events
    }
    
    
    private func makeOngoing(_ id:ObjectId) -> [Int]{
        var ongoing = [Int]()
        let collection = try? LoginViewController.db?.collection("Ongoing")
        let query : Document = ["Parent": id]
        do {
            let document = try collection?!.find(query)
            let doc = document?.next()
            if doc!["Sunday"] as! Int == 1 {
                ongoing.append(0)
            }
            if doc!["Monday"] as! Int == 1 {
                ongoing.append(1)
            }
            if doc!["Tuesday"] as! Int == 1 {
                ongoing.append(2)
            }
            if doc!["Wednesday"] as! Int == 1 {
                ongoing.append(3)
            }
            if doc!["Thursday"] as! Int == 1 {
                ongoing.append(4)
            }
            if doc!["Friday"] as! Int == 1 {
                ongoing.append(5)
            }
            if doc!["Saturday"] as! Int == 1 {
                ongoing.append(6)
            }
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        return ongoing
    }
    
    @IBAction func sideBar(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? AdminSettingsTableViewCell
        if indexPath.row == 0 {
            cell?.name.text = "Delete an Account"
        }
        else if indexPath.row == 1 {
            cell?.name.text = "Promote/Demote an Account"
        }
        else if indexPath.row == 2 {
            cell?.name.text = "Academics"
        }
        return cell!
    }
    
    func studentsOnly() -> [User] {
        var students = [User]()
        for i in team {
            if i.delegation == "user" {
                students.append(i)
            }
        }
        return students
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "Delete", sender: self)
                    }
        else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "Pro/Dem", sender: self)
        }
        else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "Academics", sender: self)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let vc = segue.destination as! AdminTableViewController
        switch(segue.identifier ?? "") {
        case "Delete":
            vc.team = self.team
            vc.whoSentMe = 0
        case "Pro/Dem":
            vc.team = self.team
            vc.whoSentMe = 1
        case "Academics":
            vc.team = studentsOnly()
            vc.whoSentMe = 2
        default:
            fatalError("Unexpected destination: \(segue.destination)")
        }
    }
    
    @IBAction func unwindToSettings(sender: UIStoryboardSegue) {
        team = [User]()
        makeTeam()
        print(team.count)
    }
}
