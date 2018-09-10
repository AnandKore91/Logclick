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
        
        LogClicker.setup()
        
        // Do any additional setup after loading the view, typically from a nib.
        LogClick(infoWithMessage: "Anand")
        LogClick(warningWithMessage: "Warning goes here.")
        LogClick(errorWithMessage: "error occured.", level: .Blocker)
        LogClick(errorWithMessage: "Error with level and priority.", level: .Major, priority: .P3)
        LogClick(exceptionWithMessage: "Exception with level and priority.", level: .Blocker, priority: .P1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

