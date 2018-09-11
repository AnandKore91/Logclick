//
//  ViewController.swift
//  AKLogClick
//
//  Created by Anand Kore on 25/10/17.
//  Copyright © 2017 Anand Kore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(LogClicker.shared.deviceInfo())
    
        Log(info: "This is informations log.")
        Log(warning: "This is Warning log.")
        Log(error: nil, message: "Error with optional error.")
        Log(exception: nil, message: "This is exceptions log.")
        Log(error: nil, message: "This is error with more details", level: .Major, priority: .P3)
        Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

