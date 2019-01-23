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
    
    public var events = [Event]()
    var gone = [Event]()
    var edited = false
    let hours = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var addEvent: UIBarButtonItem!
    var day : Int?
    var month : Int?
    var year : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events.sort(by: <)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hours.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        if hours[indexPath.row] == events[0].startTimeH{
            let event = events[0]
            cell.eventLabel.text = event.name
            let dateS = Calendar.current.date(bySettingHour: event.startTimeH, minute: event.minS, second: 0, of: Date())!
            let dateE = Calendar.current.date(bySettingHour: event.endTimeH, minute: event.minE, second: 0, of: Date())!
            cell.startTime.text = dateFormat("h:mm a", dateS)
            cell.endTime.text = dateFormat("h:mm a", dateE)
            cell.location.text = event.location
        }
        else {
            cell.eventLabel.text = "Free"
            print(indexPath.row % 24)
            let dateS = Calendar.current.date(bySettingHour: hours[indexPath.row % 24], minute: 0, second: 0, of: Date())!
            let dateE = Calendar.current.date(bySettingHour: hours[(indexPath.row + 1) % 24], minute: 0, second: 0, of: Date())!
            cell.startTime.text = dateFormat("h:mm a", dateS)
            cell.endTime.text = dateFormat("h:mm a", dateE)
            
        }
        
        

        // Configure the cell...

        return cell
    }
    
    func dateFormat(_ format:String, _ conv:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: conv)
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let event = events[indexPath.row]
//        let s = event.startTimeH
//        let e = event.endTimeH
//        let f = e - s
//        return CGFloat(f * 70)
//    }

    
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
            gone.append(events[indexPath.row])
            events.remove(at: indexPath.row)
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
                    
                    let selectedEvent = events[indexPath.row]
                    eventDetailViewController.event = selectedEvent
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
