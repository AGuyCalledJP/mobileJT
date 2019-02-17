//
//  LoginViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import MongoSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submit: UIButton!
    var client : MongoClient?
    var db : MongoDatabase?
    var user = User()
    var use : String?
    var pass : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try initalizeMongo()
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
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
        
        client = try MongoClient(connectionString: "mongodb://localhost:27017")
        db = try client?.db("mobileJT")
        
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
            segue.destination as! PathController
            PathController.user = self.user!
        case "NewUser":
            print("Adding User")
        default:
            fatalError("Unexpected destination: \(segue.destination)")
        }
    }
    
    //Update this once events are saving to make it load events for the user
    func login() throws {
        let collection = try? db?.collection("Users")
        let query : Document = ["Username": use!, "Password": pass!]
        do {
            let document = try collection?!.find(query)
            let doc = document!.next()!
            let fName = doc["fName"] as! String
            let lName = doc["lName"] as! String
            let height = doc["Height"] as! Int
            let weight = doc["Weight"] as! Int
            let email = doc["Email"] as! String
            let username = doc["Username"] as! String
            let password = doc["Password"] as! String
            //Update in the future
            let events = [Event]()
            user = User(fName, lName, height, weight, events, username, password, email)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
    }
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewMemberTableViewController, let user = sourceViewController.user {
            let collection = try? db?.collection("Users")
            let query : Document = ["_id"]
            var id : Int?
            do {
                let documents = try collection?!.find(query)
                var total = 0
                for _ in documents! {
                    total += 1
                }
                id = total + 1
            }
            catch {
                print("Error with Mongodb: \(error)")
            }
            if !(user.userName?.isEmpty)!, let realId = id {
                let doc: Document = ["_id": realId, "fName": user.fName!, "lName": user.lName!, "Height": user.height!, "Weight": user.weight!, "Email": user.email!, "Username": user.userName!, "Password": user.password!, "Events" : realId]
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
    }
}
