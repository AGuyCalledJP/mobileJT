//
//  AddEventViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 1/14/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import os.log

class AddEventViewController: UIViewController, UITextFieldDelegate {
    var event : Event?
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        repeatLabel.text = "Repeat?"
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
        let name = eventName.text
        let loc = location.text
        let ongoing = repeatSwitch.isOn
        let date = datePicker.date
        print("date")
        print(date)
        
        self.event = Event(name!, 0, 1, ongoing, loc!,0,1)
    }
}