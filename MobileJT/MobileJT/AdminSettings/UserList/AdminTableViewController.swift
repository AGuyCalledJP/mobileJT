//
//  AdminTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/26/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import MongoSwift

class AdminTableViewController: UITableViewController {
    
    var team = [User]()
    var whoSentMe = 0
    var selected = 0
    
    @IBOutlet weak var done: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if whoSentMe == 0 {
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTableViewCell", for: indexPath) as? AdminTableViewCell
        let use = team[indexPath.row]
        cell?.fname.text = use.fName
        cell?.lname.text = use.lName
        cell?.user = use
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        if whoSentMe == 2 {
            self.performSegue(withIdentifier: "Class Listings", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            RemoveUser(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func RemoveUser(_ elem: Int) {
        let goodbye = team[elem]
        let collection = try? LoginViewController.db?.collection("Users")
        let query : Document = ["Username": goodbye.userName!]
        do {
            let document = try collection?!.findOneAndDelete(query)
        }
        catch {
            print("Error with Mongodb: \(error)")
        }
        team.remove(at: elem)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func done (_ sender: UIBarButtonItem) {        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === done else {
            switch(segue.identifier ?? "") {
            case "Class Listings":
                print(self.selected)
                let nextVC = segue.destination as! ClassListingTableViewController
                nextVC.user = team[self.selected]
            default:
                print(segue.destination)
                fatalError("Unexpected destination: \(segue.destination)")
            }
            return
        }
    }

}
