//
//  DayCollectionViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/7/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit

class DayCollectionViewController: UICollectionViewController {
    
    var days = [Day?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleDays()
    }
    
    public func loadSampleDays() {
        let m1 = Event("Optimization", 9, 10, true, "Thompson 391")!
        let m2 = Event("Capstone", 12, 13, true, "Thompson 409")!
        let m3 = Event("Operating Systems", 12, 14, true, "Thompson 409")!
        var ev1 = [Event?]()
        ev1.append(m1)
        ev1.append(m2)
        ev1.append(m3)
        let day1 = Day(1,"Monday",ev1 as! [Event])
        let t1 = Event("Optimization", 10, 11, true, "Thompson 391")!
        var ev2 = [Event?]()
        ev2.append(t1)
        let day2 = Day(2,"Tuesday", ev2 as! [Event])
        let w1 = Event("Optimization", 9, 10, true, "Thompson 391")!
        let w2 = Event("Capstone", 12, 13, true, "Thompson 409")!
        let w3 = Event("Operating Systems", 12, 14, true, "Thompson 409")!
        var ev3 = [Event?]()
        ev3.append(w1)
        ev3.append(w2)
        ev3.append(w3)
        let day3 = Day(3,"Wednesday", ev3 as! [Event])
        let th1 = Event("Optimization", 10, 11, true, "Thompson 391")!
        let th2 = Event("Optimization", 11, 13, true, "Thompson 391")!
        let th3 = Event("Optimization", 13, 15, true, "Thompson 391")!
        var ev4 = [Event?]()
        ev4.append(th1)
        ev4.append(th2)
        ev4.append(th3)
        let day4 = Day(4,"Thursday", ev4 as! [Event])
        let f1 = Event("Optimization", 9, 10, true, "Thompson 391")!
        let f2 = Event("Capstone", 12, 13, true, "Thompson 409")!
        let f3 = Event("Operating Systems", 12, 14, true, "Thompson 409")!
        var ev5 = [Event?]()
        ev5.append(f1)
        ev5.append(f2)
        ev5.append(f3)
        let day5 = Day(5,"Friday",ev5 as! [Event])
        let s1 = Event("Hand on cock", 0, 23, true, "Couch")!
        var ev6 = [Event?]()
        ev6.append(s1)
        let day6 = Day(6,"Saturday",ev6)
        let s2 = Event("Hand on cock", 0, 23, true, "Couch")!
        var ev7 = [Event?]()
        ev7.append(s2)
        let day7 = Day(7,"Sunday",ev7)
        days.append(day1)
        days.append(day2)
        days.append(day3)
        days.append(day4)
        days.append(day5)
        days.append(day6)
        days.append(day7)
    }
    // MARK: - Table view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
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
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            print("moving down a layer")
            guard let eventsForTheDay = segue.destination as? EventTableViewController else {
                fatalError("Shits wack yo")
            }
            guard let selectedDayCell = sender as? DayCollectionViewCell else {
                fatalError("Unexpected sender: \(sender!)")
            }
            guard let indexPath = collectionView.indexPath(for: selectedDayCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedDay = days[indexPath.row]
            eventsForTheDay.events = (selectedDay?.events)! as! [Event]
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
        
    }

}
