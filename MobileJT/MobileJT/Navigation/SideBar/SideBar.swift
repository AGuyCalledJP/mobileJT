//
//  SideBar.swift
//  MobileJT
//
//  Created by Jared Polonitza on 2/16/19.
//  Copyright © 2019 Jared Polonitza. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class SideBar: UISideMenuNavigationController {
    
    var user = User()
    
    
    open var menuPushStyle: MenuPushStyle = .popWhenPossible
    open var menuPresentMode: MenuPresentMode = .menuDissolveIn
    open var menuAlwaysAnimate = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
    }

}
