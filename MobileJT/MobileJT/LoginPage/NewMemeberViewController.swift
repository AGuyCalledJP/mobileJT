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

class NewMemberTableViewController: UITableViewController, UITextFieldDelegate {
    var fName : String?
    var lName : String?
    var height : Int?
    var weight : Int?
    var email : String?
    var userName : String?
    var password : String?
    var user : User?
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    //Need to also do the unwind method for bringing in the user information into the login page. Unwind to
    @IBAction func cancel(_ sender: UIBarButtonItem) {        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Personal", for: indexPath) as? LabelCell
            return cell!
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fName", for: indexPath) as? fName
            cell?.fName.delegate = self
            return cell!
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lName", for: indexPath) as? lName
            cell?.lName.delegate = self
            return cell!
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Height", for: indexPath) as? Height
            cell?.height.delegate = self
            return cell!
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Weight", for: indexPath) as? Weight
            cell?.weight.delegate = self
            return cell!
        }
        else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Blank", for: indexPath) as? BlankCell
            return cell!
        }
        else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Account", for: indexPath) as? LabelCell
            return cell!
        }
        else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Email", for: indexPath) as? Email
            cell?.email.delegate = self
            return cell!
        }
        else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Username", for: indexPath) as? Username
            cell?.username.delegate = self
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Password", for: indexPath) as? Password
            cell?.password.delegate = self
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
        print(textField.placeholder!)
        if textField.placeholder == "First Name" {
            fName = textField.text!
        }
        else if textField.placeholder == "Last Name" {
            lName = textField.text!
        }
        else if textField.placeholder == "Height (in inches)" {
            height = Int(textField.text!)
        }
        else if textField.placeholder == "Weight (lbs)" {
            weight = Int(textField.text!)
        }
        else if textField.placeholder == "Email" {
            email = textField.text!
        }
        else if textField.placeholder == "Username" {
            userName = textField.text!
        }
        else if textField.placeholder == "Password" {
            password = textField.text!
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateSaveButtonState(textField)
        if textField.placeholder == "First Name" {
            fName = textField.text!
        }
        else if textField.placeholder == "Last Name" {
            lName = textField.text!
        }
        else if textField.placeholder == "Height (in inches)" {
            height = Int(textField.text!)
        }
        else if textField.placeholder == "Weight (lbs)" {
            weight = Int(textField.text!)
        }
        else if textField.placeholder == "Email" {
            email = textField.text!
        }
        else if textField.placeholder == "Username" {
            userName = textField.text!
        }
        else if textField.placeholder == "Password" {
            password = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === save else {
            return
        }
        let events = [Event]()
        let u = User(fName!, lName!, height!, weight!, events, userName!, password!, email!)
        user = u
    }
}
