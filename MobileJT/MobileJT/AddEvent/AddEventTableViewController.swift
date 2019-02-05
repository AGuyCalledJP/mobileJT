//
//  AddEventTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/3/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import MultiSelectSegmentedControl

class AddEventTableViewController: UITableViewController, UITextFieldDelegate {
    var event : Event?
    var cellText = [String]()
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    

    override func viewDidLoad() {
        event = Event()
        super.viewDidLoad()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventNameCell", for: indexPath) as? EventNameCell
            cell?.eventTitle.delegate = self
            return cell!
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventLocationCell", for: indexPath) as? EventLocationCell
            cell?.eventLocation.delegate = self
            return cell!
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllDayCell", for: indexPath) as? AllDayCell
            return cell!
            //Add some stuff here when all day is working
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StartDateCell", for: indexPath) as? StartDateCell
            cell?.startDate.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell!
        }
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EndDateCell", for: indexPath) as? EndDateCell
            cell?.endDate.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell!
        }
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCell", for: indexPath) as? RepeatCell
            cell?.repeatWhen.addTarget(self, action: #selector(daysChange), for: .valueChanged)
            return cell!
        }
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EndRepeatCell", for: indexPath) as? EndRepeatCell
            cell?.endRepeatDate.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            return cell!
        }
        else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncorpCalCell", for: indexPath) as? IncorpCalCell
            return cell!
        }
        else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath) as? BlankCell
            return cell!
        }
    }
    
    private func updateSaveButtonState(_ textField: UITextField) {
        // Disable the Save button if the text field is empty.
        let text = textField.text ?? ""
        save.isEnabled = !text.isEmpty
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        save.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (!cellText.contains(textField.text!)) {
            cellText.append(textField.text!)
        }
        print(cellText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState(textField)
        if (!cellText.contains(textField.text!)) {
            cellText.append(textField.text!)
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        print(datePicker)
    }
    
    @objc func daysChange(_ seg: MultiSelectSegmentedControl) {
        print(seg)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return CGFloat(200)
        }
        else if indexPath.row == 5 {
            return CGFloat(200)
        }
        else if indexPath.row == 6 {
            return CGFloat(70)
        }
        else if indexPath.row == 7 {
            return CGFloat(200)
        }
        else {
            return CGFloat(50)
        }
    }

    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === save else {
            return
        }
        for i in 0...9 {
            let indexPath = IndexPath(row: i, section: 0)
            print(indexPath.row)
            let dateFormatter = DateFormatter()
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventNameCell", for: indexPath) as? EventNameCell
                print("Yo Dude")
                print(cell?.eventTitle.text!)
                event?.name = ((cell?.eventTitle.text!)!)
                print(event?.name)
                print("REally")
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EventLocationCell", for: indexPath) as? EventLocationCell
                event?.location = (cell?.eventLocation.text)!
                print(event?.location)
            }
            else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AllDayCell", for: indexPath) as? AllDayCell
                //Add some stuff here when all day is working
            }
            else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StartDateCell", for: indexPath) as? StartDateCell
                let start = cell!.startDate.date
                dateFormatter.dateFormat = "yyyy"
                let yearS: String = dateFormatter.string(from: start)
                dateFormatter.dateFormat = "MM"
                let monthS: String = dateFormatter.string(from: start)
                dateFormatter.dateFormat = "dd"
                let dayS: String = dateFormatter.string(from: start)
                dateFormatter.dateFormat = "HH"
                let hourS: String = dateFormatter.string(from: start)
                dateFormatter.dateFormat = "mm"
                let minS: String = dateFormatter.string(from: start)
                event?.yearS = Int(yearS)!
                event?.monthS = Int(monthS)!
                event?.dayS = Int(dayS)!
                event?.startTimeH = Int(hourS)!
                event?.minS = Int(minS)!
            }
            else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EndDateCell", for: indexPath) as? EndDateCell
                let end = cell!.endDate.date
                dateFormatter.dateFormat = "yyyy"
                let yearE: String = dateFormatter.string(from: end)
                dateFormatter.dateFormat = "MM"
                let monthE: String = dateFormatter.string(from: end)
                dateFormatter.dateFormat = "dd"
                let dayE: String = dateFormatter.string(from: end)
                dateFormatter.dateFormat = "HH"
                let hourE: String = dateFormatter.string(from: end)
                dateFormatter.dateFormat = "mm"
                let minE: String = dateFormatter.string(from: end)
                event?.yearE = Int(yearE)!
                event?.monthE = Int(monthE)!
                event?.dayE = Int(dayE)!
                event?.endTimeH = Int(hourE)!
                event?.minE = Int(minE)!
                print(yearE)
            }
            else if indexPath.row == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCell", for: indexPath) as? RepeatCell
                let hold = cell?.repeatWhen.selectedSegmentIndexes
                var ongoing = [Int]()
                for i in hold! {
                    ongoing.append(i)
                }
                event?.ongoing = ongoing
            }
            else if indexPath.row == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EndRepeatCell", for: indexPath) as? EndRepeatCell
                let hardEnd = cell!.endRepeatDate.date
                dateFormatter.dateFormat = "yyyy"
                let yearE: String = dateFormatter.string(from: hardEnd)
                dateFormatter.dateFormat = "MM"
                let monthE: String = dateFormatter.string(from: hardEnd)
                dateFormatter.dateFormat = "dd"
                let dayE: String = dateFormatter.string(from: hardEnd)
                event?.yearE = Int(yearE)!
                event?.monthE = Int(monthE)!
                event?.dayE = Int(dayE)!
            }
            else if indexPath.row == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncorpCalCell", for: indexPath) as? IncorpCalCell
                //Do stuff when fucntioning later
            }
            else {
                print("wrong choice")
            }
        }
        print(event!)
    }
}
