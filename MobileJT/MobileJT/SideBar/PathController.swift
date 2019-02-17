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

class PathController: UITableViewController {
    
    var locations = ["Profile", "Calendar"]
    var user = User()
    
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
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIdentifier = "SideBarProfileCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarProfileCell  else {
                fatalError("The dequeued cell is not an instance of SideBarProfileCell.")
            }
            cell.label.text = locations[indexPath.row]
            
            return cell
        }
        else {
            let cellIdentifier = "SideBarCalCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideBarCalCell  else {
                fatalError("The dequeued cell is not an instance of SideBarCalCell.")
            }
            cell.label.text = locations[indexPath.row]
            
            return cell
        }
    }
}
