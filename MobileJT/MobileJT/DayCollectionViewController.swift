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
        let day1 = Day(1,"Monday")
        let day2 = Day(2,"Tuesday")
        let day3 = Day(3,"Wednesday")
        let day4 = Day(4,"Thursday")
        let day5 = Day(5,"Friday")
        let day6 = Day(6,"Saturday")
        let day7 = Day(7,"Sunday")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
