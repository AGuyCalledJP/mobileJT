//
//  AddEventTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/17/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import os.log
import MultiSelectSegmentedControl

class AddEventTableViewController: UITableViewController {
    var event : Event?
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    var indexPaths = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...4 {
            let path = NSIndexPath(row: i, section: 0)
            indexPaths.append(path)
        }
        print(indexPaths)
        let c = tableView.cellForRow(at: indexPaths[0] as IndexPath) as! AddEventTableViewCell
        print(c)
        var cell = tableView.cellForRow(at: indexPaths[2] as IndexPath) as! AddEventTableViewCell
        cell.startLabel.text = "Start Time"
        cell = tableView.cellForRow(at: indexPaths[3] as IndexPath) as! AddEventTableViewCell
        cell.endLabel.text = "End Time"
        cell = tableView.cellForRow(at: indexPaths[3] as IndexPath) as! AddEventTableViewCell
        cell.repeatLabel.text = "Repeat"
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let cell = tableView.cellForRow(at: indexPaths[0] as IndexPath) as! AddEventTableViewCell
        let text = cell.eventName.text ?? ""
        save.isEnabled = !text.isEmpty
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        save.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddItemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === save else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        //get the information from the user form
        var cell = tableView.cellForRow(at: indexPaths[0] as IndexPath) as! AddEventTableViewCell
        let name = cell.eventName.text
        cell = tableView.cellForRow(at: indexPaths[1] as IndexPath) as! AddEventTableViewCell
        let loc = cell.eventLoc.text
        cell = tableView.cellForRow(at: indexPaths[4] as IndexPath) as! AddEventTableViewCell
        let hold = cell.repeatPicker.selectedSegmentIndexes
        var ongoing = [Int]()
        for i in hold! {
            ongoing.append(i)
        }
        let dateFormatter = DateFormatter()
        cell = tableView.cellForRow(at: indexPaths[2] as IndexPath) as! AddEventTableViewCell
        let start = cell.startDate.date
        cell = tableView.cellForRow(at: indexPaths[3] as IndexPath) as! AddEventTableViewCell
        let end = cell.endDate.date
        dateFormatter.dateFormat = "yyyy"
        let yearS: String = dateFormatter.string(from: start)
        let yearE: String = dateFormatter.string(from: end)
        dateFormatter.dateFormat = "MM"
        let monthS: String = dateFormatter.string(from: start)
        let monthE: String = dateFormatter.string(from: end)
        dateFormatter.dateFormat = "dd"
        let dayS: String = dateFormatter.string(from: start)
        let dayE: String = dateFormatter.string(from: end)
        dateFormatter.dateFormat = "HH"
        let hourS: String = dateFormatter.string(from: start)
        let hourE: String = dateFormatter.string(from: end)
        dateFormatter.dateFormat = "mm"
        let minS: String = dateFormatter.string(from: start)
        let minE: String = dateFormatter.string(from: end)
        let yS = Int(yearS)
        let yE = Int(yearE)
        let MS = Int(monthS)
        let ME = Int(monthE)
        let dS = Int(dayS)
        let dE = Int(dayE)
        let hS = Int(hourS)
        let hE = Int(hourE)
        let mS = Int(minS)
        let mE = Int(minE)
        
        //Save the event and return back up
        self.event = Event(name!,ongoing, loc!, yS!, yE!, MS!, ME!, dS!, dE!, hS!, hE!, mS!, mE!)
    }
}
