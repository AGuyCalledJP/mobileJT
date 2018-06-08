//
//  ViewController.swift
//  MobileJT
//
//  Created by Jared Polonitza on 6/6/18.
//  Copyright © 2018 Thick Enterprises. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Actions
    @IBAction func updateLabel(_ sender: UIButton) {
        label.text = "please"
    }
    
}
