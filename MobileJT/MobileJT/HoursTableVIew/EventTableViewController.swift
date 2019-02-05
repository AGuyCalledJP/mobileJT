//
//  EventTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 12/19/18.
//  Copyright © 2018 Jared Polonitza. All rights reserved.
//

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
    var year : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(events[0].startTimeH)
        makeMyDay()
    }
    
    func makeMyDay() {
        todos = [Event]()
        var interval = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
        events.sort(by: <)
        var ind = 1
        var j = 0
        todos.append(Event(hours[interval[0]], hours[(interval[0] + 1) % 24])!)
        while (ind < interval.count || j < events.count) {
            if (j < events.count) {
                if (events[j].startTimeH >= interval[ind - 1] && events[j].startTimeH <= interval[ind]) {
                    todos.append(events[j])
                    link.append(ind)
                    j += 1
                    ind += 1
                }
                else {
                    todos.append(Event(hours[interval[ind]], hours[(interval[ind] + 1) % 24])!)
                    ind += 1
                }
            }
            else {
                todos.append(Event(hours[interval[ind]], hours[(interval[ind] + 1) % 24])!)
                ind += 1
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
            cell.endTime.text = dateFormat("h:mm a", dateE)
            cell.location.text = event.location
            return cell
        }
        else {
            let cellIdentifier = "FreeHourTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FreeHourTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FreeHourTableViewCell.")
            }
            let event = todos[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = todos[indexPath.row]
        let s = event.startTimeH
        let e = event.endTimeH
        if (e < s) {
            let f = e + 24
            let z = f - s
            return CGFloat(z * 70)
        }
        else {
            let f = e - s
            return CGFloat(f * 70)
        }
    }

    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EventViewController, let event = sourceViewController.event {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: events.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
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
                default:
                    print("Unexpected Segue Identifier; \(segue.identifier!)")
                    return
                }
            return
            }
        if (button === addEvent) {
            guard let addItem = segue.destination as? UINavigationController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            let additemVC = addItem.viewControllers[0] as? AddEventViewController
            var dateComponents = DateComponents()
            dateComponents.year = self.year!
            dateComponents.month = self.month!
            dateComponents.day = self.day!
            dateComponents.hour = 8
            dateComponents.minute = 0
            let userCalendar = Calendar.current // user calendar
            let date = userCalendar.date(from: dateComponents)
            additemVC!.date = date!
        }
    }
}
