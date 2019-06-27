//
//  ClassListingTableViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/26/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit

class ClassListingTableViewController: UITableViewController {

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user?.events!.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassListingCell", for: indexPath) as? ClassListingTableViewCell

        cell?.CourseTitle.text = user!.events![indexPath.row].name
        cell?.time.text = "Hold this for the minute"
        cell?.location.text = user!.events![indexPath.row].location

        return cell!
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
