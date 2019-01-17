//
//  DayCollectionViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/7/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import os.log

class DayCollectionViewController: UICollectionViewController {
    
    var days = [Day?]()
    var month = Month()
    var currentMonth = 0
    var currentYear = 2019
    var allEvents = [Event?]()
    @IBOutlet weak var addEvent: UIBarButtonItem!
    //    static var eventManager = EventManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.month = loadMonth()
        let name = month?.monthName
        let year = String(currentYear)
        self.title = name! + " " + year
        self.days = (month?.days)!
        print(allEvents)
        navigationItem.leftBarButtonItem?.title = (month?.prevMonth())!
        navigationItem.rightBarButtonItem?.title = (month?.nextMonth())!
    }
    
    //Change this from loading days to loading a month of days at a time
    func loadMonth() -> Month{
        let month = Month(currentMonth, currentYear, allEvents)
        return month!
    }
    
    func reloadData() {
        self.month = loadMonth()
        let name = month?.monthName
        let year = String(currentYear)
        self.title = name! + " " + year
        self.days = (month?.days)!
        navigationItem.leftBarButtonItem?.title = (month?.prevMonth())!
        navigationItem.rightBarButtonItem?.title = (month?.nextMonth())!
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
        return days.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "DayCollectionViewCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DayCollectionViewCell
            else {
                fatalError("Dammit")
            }

        let day = days[indexPath.row]
        
        cell.dayNumber.text = String(day!.dayNum)
        cell.dayName.text = day!.dayInWeek
        
        return cell
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
            
            let selectedDay = days[indexPath.row]
            dayDetailTableViewController.events = selectedDay!.events as! [Event]
        case "AddItem":
            print("adding item")
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEventViewController, let event = sourceViewController.event {
            
            allEvents.append(event)
            reloadData()
            // Save the meals.
            saveEvents()
            self.collectionView.reloadData()
        }
    }
    
    
    
    private func saveEvents() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allEvents, toFile: Event.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recurring events saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save events...", log: OSLog.default, type: .error)
        }
        print(allEvents)
    }
    
    private func loadEvents() -> [Event]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Event.ArchiveURL.path) as? [Event]
    }


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
