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
    var dayInWeek : String?
    var dayInYear : Int?
    var month : Int?
    var year : Int?
    let months = ["January","February","March","April","May","June",
                  "July","August","September","October","November", "December"]
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let event = event {
            navigationItem.title = event.name
            eventName.text = event.name
            let dateS = Calendar.current.date(bySettingHour: event.startTimeH, minute: event.minS, second: 0, of: Date())!
            let dateE = Calendar.current.date(bySettingHour: event.endTimeH, minute: event.minE, second: 0, of: Date())!
            startTime.text = dateFormat("h:mm a", dateS)
            endTime.text = dateFormat("h:mm a", dateE)
            let date = dayInWeek! + ", " + months[month!] + " " + String(dayInYear!) +  ", " + String(year!)
            day.text = date
            location.text = event.location
        }
    }
    
    public func dateFormat(_ format:String, _ conv:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: conv)
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

