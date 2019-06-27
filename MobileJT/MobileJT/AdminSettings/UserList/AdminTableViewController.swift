//
//  AdminTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/26/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit

class AdminTableViewController: UITableViewController {
    
    var team = [User]()
    var whoSentMe = 0
    var selected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.performSegue(withIdentifier: "Class Listings", sender: self)
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
        switch(segue.identifier ?? "") {
        case "Class Listings":
            print(self.selected)
            let nextVC = segue.destination as! ClassListingTableViewController
            nextVC.user = team[self.selected]
        default:
            print(segue.destination)
            fatalError("Unexpected destination: \(segue.destination)")
        }
    }

}
