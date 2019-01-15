//
//  ViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 12/19/18.
//  Copyright © 2018 Jared Polonitza. All rights reserved.
//

import UIKit
import os.log

class EventViewController: UIViewController {
    var event : Event?
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let event = event {
            navigationItem.title = event.name
            eventName.text = event.name
            startTime.text = event.dispStart
            endTime.text = event.dispEnd
            location.text = event.location
        }
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
}

