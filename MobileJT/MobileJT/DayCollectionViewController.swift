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
        let e1 = Event("Optimization", 9, 10, true, "Thompson")
        let e2 = Event("Capstone", 10, 11, true, "Thompson")
        let e3 = Event("Operating Systems", 14, 15, true, "Thompson")
        var m = [Event]()
        m.append(e1!)
        m.append(e2!)
        m.append(e3!)
        let day1 = Day(1,"Monday",m)
        let e4 = Event("Optimization", 9, 10, true, "Thompson")
        var t = [Event]()
        t.append(e4!)
        let day2 = Day(2,"Tuesday",t)
        var w = [Event]()
        w.append(e1!)
        w.append(e2!)
        w.append(e3!)
        let day3 = Day(3,"Wednesday",w)
        var th = [Event]()
        th.append(e4!)
        let day4 = Day(4,"Thursday",th)
        var f = [Event]()
        f.append(e1!)
        f.append(e2!)
        f.append(e3!)
        let day5 = Day(5,"Friday",f)
        let weekend = Event("Hand on Cock", 0, 23, true, "Couch")
        var s = [Event]()
        s.append(weekend!)
        let day6 = Day(6,"Saturday",s)
        var s2 = [Event]()
        s2.append(weekend!)
        let day7 = Day(7,"Sunday",s2)
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
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier!)")
        }
    }

}