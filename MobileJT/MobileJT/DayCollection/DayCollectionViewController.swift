//
//  DayCollectionViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/7/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import os.log
import SideMenu
import MongoSwift

class DayCollectionViewController: UICollectionViewController {
    
    var allEvents = [Event?]()
    var user = User()
    var uid : ObjectId?
    
    var days = [Day?]()
    var month : Month?
    var currentMonth = 0
    var currentYear = 2019
    var daysFromSet : Int?
    let curr = Date()
    var date = [Int]()
    
    @IBOutlet weak var addEvent: UIBarButtonItem!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newCurr = dateFormat("MM/dd/yyyy", curr)
        date = [Int]()
        let hold1 = newCurr.split(separator: "/")
        for i in hold1 {
            date.append((Int(i))!)
        }
        currentMonth = date[0] - 1
        currentYear = date[2]
        self.month = loadMonth()
        self.daysFromSet = month?.firstDay()
        let name = month?.monthName
        let year = String(currentYear)
        self.title = name! + " " + year
        self.days = (month?.days)!
        navigationItem.leftBarButtonItems![1].title = (month?.prevMonth())!
        navigationItem.rightBarButtonItems![1].title = (month?.nextMonth())!
    }
    
    //Change this from loading days to loading a month of days at a time
    func loadMonth() -> Month{
        let month = Month(currentMonth, currentYear, allEvents)
        return month!
    }
    
    func reloadData() {
        self.month = loadMonth()
        self.daysFromSet = month?.firstDay()
        let name = month?.monthName
        let year = String(currentYear)
        self.title = name! + " " + year
        self.days = (month?.days)!
        navigationItem.leftBarButtonItems![1].title = (month?.prevMonth())!
        navigationItem.rightBarButtonItems![1].title = (month?.nextMonth())!
    }
    
    
    @IBAction func monthDown(_ sender: Any) {
        if currentMonth > 0 {
            currentMonth -= 1
        }
        else {
            currentMonth = 11
            currentYear -= 1
        }
        reloadData()
        self.collectionView.reloadData()
    }
    
    @IBAction func monthUp(_ sender: Any) {
        if currentMonth < 11 {
            currentMonth += 1
        }
        else {
            currentMonth = 0
            currentYear += 1
        }
        reloadData()
        self.collectionView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count + daysFromSet!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < daysFromSet!) {
            let reuseIdentifier = "SpaceCell"
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SpaceCell
                else {
                    fatalError("Dammit")
            }
            cell.backgroundColor = .white
            
            return cell
        }
        else {
            let reuseIdentifier = "DayCollectionViewCell"
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DayCollectionViewCell
                else {
                    fatalError("Dammit")
            }
            let day = days[indexPath.row - daysFromSet!]
            print(date)
            if ((month?.getMonth())! + 1 == date[0]) && (day?.dayNum)! == date[1] && currentYear == date[2] {
                cell.backgroundColor = .blue
            }
            else if !(day?.events.isEmpty)! {
                cell.backgroundColor = .red
            }
            else {
                cell.backgroundColor = .white
            }
            cell.dayNumber.text = String(day!.dayNum)
            cell.dayName.text = day!.dayInWeek
            return cell
        }
    }
    
    func dateFormat(_ format:String, _ conv:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: conv)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let dayDetailTableViewController = segue.destination as? EventTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDayCell = sender as? DayCollectionViewCell else {
                fatalError("Unexpected sender: \(sender!)")
            }
            
            guard let indexPath = collectionView.indexPath(for: selectedDayCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDay = days[indexPath.row - daysFromSet!]
            dayDetailTableViewController.events = selectedDay!.events as! [Event]
            dayDetailTableViewController.day = selectedDay?.dayNum
            dayDetailTableViewController.month = (month?.getMonth())! + 1
            dayDetailTableViewController.year = currentYear
            dayDetailTableViewController.dayInWeek = selectedDay?.dayInWeek
            dayDetailTableViewController.monthString = selectedDay?.month
            dayDetailTableViewController.setDay()
        case "AddItem":
            print("adding item")
        case "SideBar":
            print("displaying sidebar")
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }
    
    @IBAction func unwindToDays(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEventTableViewController, let event = sourceViewController.event {
            allEvents.append(event)
            saveEvent(event)
            user?.events = allEvents as! [Event]
            reloadData()
            self.collectionView.reloadData()
        }
        else if let sourceViewController = sender.source as? EventTableViewController {
            let check = sourceViewController.edited
            if check {
                let hold = sourceViewController.gone
                for e in hold {
                    let v = allEvents.index(of: e)
                    allEvents.remove(at: v!)
                    removeEvent(e)
                    user?.events = allEvents as! [Event]
                }
            }
            reloadData()
        }
    }
    
    @IBAction func sideBar(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    private func saveEvent(_ event:Event) {
        let collection = try? LoginViewController.db?.collection("Events")
        let doc: Document = ["UserId": self.uid!, "Name": event.name, "Location": event.location, "StartTimeH": event.startTimeH, "EndTimeH": event.endTimeH, "MinS": event.minS, "MinE": event.minE, "MonthS": event.monthS, "MonthE": event.monthE, "YearS": event.yearS, "YearE": event.yearE, "DayS": event.dayS, "DayE": event.dayE]
        do {
            try collection!!.insertOne(doc)
            
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        var id : ObjectId?
        do {
            let document = try collection?!.find(doc)
            let res = document!.next()!
            id = res["_id"] as! ObjectId

        }
        catch {
            print("Somehow that document you just made doesnt exits \(error)")
        }
        let collection2 = try? LoginViewController.db?.collection("Ongoing")
        var collec = [0,0,0,0,0,0,0]
        for i in 1...collec.count {
            if event.ongoing.contains(i) {
                collec[i] = 1
            }
        }
        let doc2: Document = ["Parent": id!, "Sunday": collec[0], "Monday": collec[1], "Tuesday": collec[2], "Wednesday": collec[3], "Thursday": collec[4], "Friday": collec[5], "Saturday": collec[6]]
        do {
            try collection2!!.insertOne(doc2)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
    }
    
    private func removeEvent(_ event:Event) {
        let collection = try? LoginViewController.db?.collection("Events")
        let doc: Document = ["UserId": self.uid!, "Name": event.name, "Location": event.location, "StartTimeH": event.startTimeH, "EndTimeH": event.endTimeH, "MinS": event.minS, "MinE": event.minE, "MonthS": event.monthS, "MonthE": event.monthE, "YearS": event.yearS, "YearE": event.yearE, "DayS": event.dayS, "DayE": event.dayE]
        var id : ObjectId?
        //delete the event and keep the id around
        do {
            let query = try collection!!.find(doc)
            let res = query.next()
            id = res!["_id"] as! ObjectId
            try collection!!.deleteOne(doc)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        
        let collection2 = try? LoginViewController.db?.collection("Ongoing")
        let find: Document = ["Parent": id!]
        do {
            let res = try collection!!.find(find)
            //Deleting an event does not yet work
            try collection!!.deleteOne(res.next()!)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        
    }
    
//    private func saveEvents() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allEvents, toFile: Event.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Recurring events saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save events...", log: OSLog.default, type: .error)
//        }
//    }
//
//    private func loadEvents() -> [Event]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Event.ArchiveURL.path) as? [Event]
//    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
