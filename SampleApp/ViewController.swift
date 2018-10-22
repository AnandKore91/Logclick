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
        
        LogClicker.shared.logsStoreLocation = .printAndDatabase
    
        Log(info: "This is informations log.")
        Log(warning: "This is Warning log.")
        Log(error: nil, message: "Error with optional error.")
        Log(exception: nil, message: "This is exceptions log.")
        Log(error: nil, message: "This is error with more details", level: .Major, priority: .P3)
        Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)
        
        for _ in 0...10{
            Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)
        }
        
        
        let logs = LogClicker.shared.getLogs(whereKeys: [WhereKey.LEVEL : IssueLevel.Blocker.rawValue, WhereKey.OS_VERSION:"12.0"], limit:10)
        print(logs)
        print("\n\n\n\n\n\n\n")
        
        print(LogClicker.shared.firstSeen(whereKeys: [WhereKey.LEVEL: IssueLevel.Blocker.rawValue]) ?? "")
        print(LogClicker.shared.firstSeen(whereKeys: [WhereKey.LOG_TYPE: LogType.tSevere.rawValue]) ?? "")
        
        print(LogClicker.shared.lastSeen(whereKeys: [WhereKey.LEVEL: IssueLevel.Blocker.rawValue]) ?? "")
        print(LogClicker.shared.lastSeen(whereKeys: [WhereKey.LOG_TYPE: LogType.tSevere.rawValue]) ?? "")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

