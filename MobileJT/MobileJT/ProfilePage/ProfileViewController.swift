//
//  ProfileViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import UIKit
import SideMenu
import MongoSwift

class ProfileViewController: UIViewController {
    
    var user = User()
    var uid : ObjectId?
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserNameLabel.text = user?.userName
        self.nameLabel.text = (user?.fName)! + " " + (user?.lName)!
        self.height.text = String(user!.height!)
        self.weight.text = String(user!.weight!
        )

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sideBar(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
