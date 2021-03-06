//
//  File.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import MongoSwift

class PathController: UITableViewController {
    
    var user = User()
    var uid : ObjectId?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        guard SideMenuManager.default.menuBlurEffectStyle == nil else {
            return
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user?.delegation == "user" {
            return 3
        }
        else {
            return 4
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if user?.delegation == "admin" {
            if indexPath.row == 0 {
                let cellIdentifier = "SideBarProfileCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarProfileCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarProfileCell.")
                }
                cell.label.text = "Profile"
                
                return cell
            }
            else if indexPath.row == 1{
                let cellIdentifier = "SideBarCalCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarCalCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarCalCell.")
                }
                cell.label.text = "Calendar"
                
                return cell
            }
            else if indexPath.row == 2 { //Make it so that if user doesnt have admin delegation this doesnt appear
                let cellIdentifier = "Settings"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarSettingsTableViewCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarSettingsTableViewCell.")
                }
                cell.label.text = "Settings"
                
                return cell
            }
            else {
                let cellIdentifier = "SideBarSignOutCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarSignOutCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarSignOutCell.")
                }
                cell.label.text = "Sign out"
                return cell
            }
        }
        else {
            if indexPath.row == 0 {
                let cellIdentifier = "SideBarProfileCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarProfileCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarProfileCell.")
                }
                cell.label.text = "Profile"
                
                return cell
            }
            else if indexPath.row == 1{
                let cellIdentifier = "SideBarCalCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarCalCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarCalCell.")
                }
                cell.label.text = "Calendar"
                
                return cell
            }
                
            else {
                let cellIdentifier = "SideBarSignOutCell"
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarSignOutCell  else {
                    fatalError("The dequeued cell is not an instance of SideBarSignOutCell.")
                }
                cell.label.text = "Sign Out"
                return cell
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "Profile":
                let s = segue.destination as! ProfileViewController
                s.user = self.user
                s.uid = self.uid
            case "Calendar":
                let s = segue.destination as! DayCollectionViewController
                s.user = self.user
                s.uid = self.uid
                s.allEvents = (self.user?.events)!
            case "Settings":
                print("Im gonna change some things around here")
            default:
                //How do I do nothing?
                let _ = 1
        }
    }
}
