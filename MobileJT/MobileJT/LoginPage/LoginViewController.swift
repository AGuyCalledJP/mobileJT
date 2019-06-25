//
//  LoginViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import MongoSwift
import CoreLocation

class LoginViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submit: UIButton!
    static var client : MongoClient?
    static var db : MongoDatabase?
    var user = User()
    var uid : ObjectId?
    var use : String?
    var pass : String?
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try initalizeMongo()
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        username.delegate = self
        password.delegate = self
    }
    
    private func updateSaveButtonState(_ textField: UITextField) {
        // Disable the Save button if the text field is empty.
        let text = textField.text ?? ""
        submit.isEnabled = !text.isEmpty
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        submit.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.placeholder!)
        if textField.placeholder == "Username" {
            use = textField.text!
        }
        else {
            pass = textField.text!
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState(textField)
        if textField.placeholder == "Username" {
            use = textField.text!
        }
        else {
            pass = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    func initalizeMongo() throws{
        // initialize global state
        MongoSwift.initialize()
        
        LoginViewController.client = try MongoClient(connectionString: "mongodb://localhost:27017")
        LoginViewController.db = try LoginViewController.client?.db("mobileJT")
//
//        do {
//            try LoginViewController.db?.createCollection("Ongoing")
//        }
//        catch {
//            print("nice")
//        }
        
        // free all resources
        MongoSwift.cleanup()
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "Login":
            print("Verifying")
            do {
               try login()
            }
            catch {
                //Need to make this error handling more specific
                print("Error with Mongodb: \(error)")
            }
            
            let navVC = segue.destination as! UINavigationController
            
            let VC = navVC.viewControllers.first as! PathController
            VC.uid = self.uid
            VC.user = self.user
        case "NewUser":
            print("Adding User")
        default:
            print(segue.destination)
            fatalError("Unexpected destination: \(segue.destination)")
        }
    }
    
    //Update this once events are saving to make it load events for the user
    func login() throws {
        let collection = try? LoginViewController.db?.collection("Users")
        let query : Document = ["Username": use!, "Password": pass!]
        do {
            let document = try collection?!.find(query)
            let doc = document!.next()!
            self.uid = doc["_id"] as! ObjectId
            let fName = doc["fName"] as! String
            let lName = doc["lName"] as! String
            let height = doc["Height"] as! Int
            let weight = doc["Weight"] as! Int
            let email = doc["Email"] as! String
            let username = doc["Username"] as! String
            let password = doc["Password"] as! String
            //Update in the future
            let events = getEvents()
            user = User(fName, lName, height, weight, events, username, password, email)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
    }
    
    private func getEvents() -> [Event] {
        var events = [Event]()
        let collection = try? LoginViewController.db?.collection("Events")
        let query : Document = ["UserId": self.uid!]
        do {
            let document = try collection?!.find(query)
            for d in document! {
                let id = d["_id"] as! ObjectId
                let name = d["Name"] as! String
                let location = d["Location"] as! String
                let startTimeH = d["StartTimeH"] as! Int
                let endTimeH = d["EndTimeH"] as! Int
                let minS = d["MinS"] as! Int
                let minE = d["MinE"] as! Int
                let monthS = d["MonthS"] as! Int
                let monthE = d["MonthE"] as! Int
                let yearS = d["YearS"] as! Int
                let yearE = d["YearE"] as! Int
                let dayS = d["DayS"] as! Int
                let dayE = d["DayE"] as! Int
                //Update in the future
                let ongoing = makeOngoing(id)
                print(ongoing)
                let e = Event(name, ongoing, location, yearS, yearE, monthS, monthE, dayS, dayE, startTimeH, endTimeH, minS, minE)
                events.append(e!)
                print("Event")
                print(e)
            }
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        return events
    }
    
    
    private func makeOngoing(_ id:ObjectId) -> [Int]{
        var ongoing = [Int]()
        let collection = try? LoginViewController.db?.collection("Ongoing")
        let query : Document = ["Parent": id]
        do {
            let document = try collection?!.find(query)
            let doc = document?.next()
            if doc!["Sunday"] as! Int == 1 {
                ongoing.append(0)
            }
            if doc!["Monday"] as! Int == 1 {
                ongoing.append(1)
            }
            if doc!["Tuesday"] as! Int == 1 {
                ongoing.append(2)
            }
            if doc!["Wednesday"] as! Int == 1 {
                ongoing.append(3)
            }
            if doc!["Thursday"] as! Int == 1 {
                ongoing.append(4)
            }
            if doc!["Friday"] as! Int == 1 {
                ongoing.append(5)
            }
            if doc!["Saturday"] as! Int == 1 {
                ongoing.append(6)
            }
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        return ongoing
    }
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewMemberTableViewController, let user = sourceViewController.user {
            let collection = try? LoginViewController.db?.collection("Users")
            if !(user.userName?.isEmpty)! {
                let doc: Document = ["fName": user.fName!, "lName": user.lName!, "Height": user.height!, "Weight": user.weight!, "Email": user.email!, "Username": user.userName!, "Password": user.password!]
                do {
                    try collection!!.insertOne(doc)
                }
                catch {
                    print("Error with Mongodb: \(error)")
                }
            }
            else {
                print("Some errors here my dude")
            }
        }
        if let sourceViewController = sender.source as? PathController {
            username.text = ""
            password.text = ""
        }
    }
}
