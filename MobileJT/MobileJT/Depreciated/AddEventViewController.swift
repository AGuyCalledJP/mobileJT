//
//  AddEventViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/14/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl
import os.log

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    var event : Event?
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatSwitch: MultiSelectSegmentedControl!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime.date = date
        endTime.date = date
        repeatLabel.text = "Repeat?"
        startLabel.text = "Start Time"
        endLabel.text = "End Time"
        eventName.delegate = self
        // Do any additional setup after loading the view.
    }

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = eventName.text ?? ""
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
        let name = eventName.text
        let loc = eventLoc.text
        let hold = repeatSwitch.selectedSegmentIndexes
        var ongoing = [Int]()
        for i in hold! {
        ongoing.append(i)
        }
        let dateFormatter = DateFormatter()
        let start = startTime.date
        let end = endTime.date
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
