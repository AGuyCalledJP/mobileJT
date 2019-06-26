//
//  EventTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 12/19/18.
//  Copyright © 2018 Jared Polonitza. All rights reserved.
//

// TODO - Add the option to check in here as well. Need some way to see if an event has been registered as checked in, and then lock the event once the checkin window has passed
import UIKit
import os.log

class EventTableViewController: UITableViewController {
    
    var events = [Event]()
    var link = [Int]()
    var todos = [Event]()
    var gone = [Event]()
    var edited = false
    let hours = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var addEvent: UIBarButtonItem!
    var day : Int?
    var dayInWeek : String?
    var month : Int?
    var monthString : String?
    var year : Int?
    var lastTouch = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeMyDay()
    }
    
    public func setDay() {
        var ending = findTerm(day!)
        let string1 = dayInWeek! + ", " + monthString!
        let string2 = " " + String(day!) + ending
        let string = string1 + string2
        self.navigationItem.title = string
    }
    
    func findTerm(_ day: Int)  -> String {
        if day == 1 || day == 2 {
            return "st"
        }
        else if day == 3 {
            return "rd"
        }
        else if day >= 4 && day <= 20 {
            return "th"
        }
        else if day >= 21 && day <= 22 {
            return "st"
        }
        else if day == 23 {
            return "rd"
        }
        else if day >= 24 && day <= 30 {
            return "th"
        }
        else {
            return "st"
        }
    }
    func makeMyDay() {
        todos = [Event]()
        var interval = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
        var totalMins = 0
        events.sort(by: <)
        var j = 0
        var totalSlots = 0
        while (totalMins < 1440) {
            if j < events.count {
                let event = events[j]
                if event.startTimeH * 60 >= totalMins  && event.startTimeH * 60 < totalMins + 60 {
                    let time = event.startTimeH * 60 + event.minS
                    let diff = time - totalMins
                    if diff > 0 {
                        var hrS : Int?
                        var minS : Int?
                        var hrE : Int?
                        var minE : Int?
                        if totalMins >= 60 {
                            hrS = Int(totalMins / 60)
                            minS = totalMins - (interval[hrS!] * 60)
                            hrE = event.startTimeH
                            minE = event.minS - 1
                        }
                        else {
                            hrS = Int(totalMins / 60)
                            minS = 0 - totalMins
                            hrE = event.startTimeH
                            minE = event.minS - 1
                        }
                        todos.append(Event(hrS!, minS!, hrE!, minE!)!)
                        totalMins += diff
                        totalSlots += 1
                        todos.append(event)
                        link.append(totalSlots)
                        totalSlots += 1
                        j += 1
                        totalMins += (event.endTimeH * 60 + event.minE) - (event.startTimeH * 60 + event.minS)
                    }
                    else {
                        todos.append(event)
                        link.append(totalSlots)
                        totalSlots += 1
                        totalMins = diff + (event.endTimeH * 60 + event.minE)
                        j += 1
                    }
                }
                else {
                    let currentHr = (totalMins) / 60
                    let nextHr = interval[currentHr + 1]
                    let getThere = currentHr * 60
                    let nextStop = nextHr * 60
                    let diff = nextStop - totalMins
                    let useThis = totalMins - getThere
                    let finDif = getThere - totalMins
                    if finDif >= 0 {
                        todos.append(Event(currentHr, finDif, nextHr, 0)!)
                    }
                    else {
                        todos.append(Event(currentHr, useThis, nextHr, 0)!)
                    }
                    totalSlots += 1
                    totalMins += diff
                }
            }
            else {
                let currentHr = (totalMins) / 60
                let nextHr = interval[currentHr + 1]
                let getThere = currentHr * 60
                let nextStop = nextHr * 60
                let diff = nextStop - totalMins
                let useThis = totalMins - getThere
                let fin = getThere - totalMins
                if fin >= 0{
                    todos.append(Event(currentHr, fin, nextHr, 0)!)
                }
                else {
                    todos.append(Event(currentHr, useThis, nextHr, 0)!)
                }
                totalSlots += 1
                totalMins += diff
            }
        }
 
            
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastTouch = indexPath.row
        self.performSegue(withIdentifier: "AddHere", sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if link.contains(indexPath.row) {
            let cellIdentifier = "EventTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
                fatalError("The dequeued cell is not an instance of EventTableViewCell.")
            }
            let event = todos[indexPath.row]
            cell.eventLabel.text = event.name
            let dateS = Calendar.current.date(bySettingHour: event.startTimeH, minute: event.minS, second: 0, of: Date())!
            let dateE = Calendar.current.date(bySettingHour: event.endTimeH, minute: event.minE, second: 0, of: Date())!
            cell.startTime.text = dateFormat("h:mm a", dateS)
//            cell.endTime.text = dateFormat("h:mm a", dateE)
            cell.location.text = event.location
            return cell
        }
        else {
            let cellIdentifier = "FreeHourTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FreeHourTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FreeHourTableViewCell.")
            }
            let event = todos[indexPath.row]
            print("Path " + String(indexPath.row))
            print(event.minS)
            print (event.startTimeH)
            let dateS = Calendar.current.date(bySettingHour: event.startTimeH, minute: event.minS, second: 0, of: Date())!
            cell.hourLabel.text = dateFormat("h:mm a", dateS)
            return cell
        }
    }
    
    func dateFormat(_ format:String, _ conv:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: conv)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let bye = todos[indexPath.row]
            gone.append(bye)
            let byebye = events.firstIndex(of: bye)
            events.remove(at: byebye!)
            todos.remove(at: indexPath.row)
            edited = true
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === done || button === addEvent else {
                switch(segue.identifier ?? "") {
                case "ShowDetail":
                    guard let eventDetailViewController = segue.destination as? EventViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                    }
                    
                    guard let selectedEventCell = sender as? EventTableViewCell else {
                        fatalError("Unexpected sender: \(sender!)")
                    }
                    
                    guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                        fatalError("The selected cell is not being displayed by the table")
                    }
                    
                    let selectedEvent = todos[indexPath.row]
                    eventDetailViewController.event = selectedEvent
                    eventDetailViewController.dayInWeek = dayInWeek!
                    eventDetailViewController.dayInYear = day
                    eventDetailViewController.month = month
                    eventDetailViewController.year = year
                case "AddHere":
                    guard let addItem = segue.destination as? UINavigationController
                        else {
                            fatalError("Unexpected destination: \(segue.destination)")
                    }
                    let additemVC = addItem.viewControllers[0] as? AddEventTableViewController
                    let chosen = todos[lastTouch]
                    var dateComponents = DateComponents()
                    dateComponents.year = self.year!
                    dateComponents.month = self.month!
                    dateComponents.day = self.day
                    dateComponents.hour = chosen.startTimeH
                    dateComponents.minute = chosen.minS
                    let userCalendar = Calendar.current // user calendar
                    let date = userCalendar.date(from: dateComponents)
                    additemVC!.date = date!
                default:
                    print("Unexpected Segue Identifier; \(segue.identifier!)")
                    return
                }
            return
            }
//        if (button === addEvent) {
//            guard let addItem = segue.destination as? UINavigationController
//                else {
//                    fatalError("Unexpected destination: \(segue.destination)")
//            }
//            let additemVC = addItem.viewControllers[0] as? AddEventTableViewController
//            var dateComponents = DateComponents()
//            dateComponents.year = self.year!
//            dateComponents.month = self.month!
//            dateComponents.day = self.day!
//            dateComponents.hour = 8
//            dateComponents.minute = 0
//            let userCalendar = Calendar.current // user calendar
//            let date = userCalendar.date(from: dateComponents)
//            additemVC!.date = date!
//        }
    }
}
