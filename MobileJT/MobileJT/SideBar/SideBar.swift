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

class SideBar: UINavigationController {
    
    open var menuPushStyle: MenuPushStyle = .popWhenPossible
    open var menuPresentMode: MenuPresentMode = .menuDissolveIn
    open var menuAlwaysAnimate = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: (self.navigationController!.viewControllers.first as? PathController)!)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
    }
}
