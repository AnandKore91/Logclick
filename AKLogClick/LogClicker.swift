//
//  AKLogClickManager.swift
//  AKLogClick
//
//  Created by Anand Kore on 25/10/17.
//  Copyright © 2017 Anand Kore. All rights reserved.
//

/*
 || ITEMS Table ||
 - ITEM     //--- Unique Log Messages
 - DATE
 - FIRST_SEEN
 - LAST_SEEN
 - TOTAL_OCCURRENCES
 - IPs_AFFECTED
 - LOG_TYPE
 - LEVEL
 - PRIORITY
 - ENVIRONMENT
 - PROJECT_NAME
 - BUNDLE_ID
 - PROJECT_VERSION
 - PROJECT_BUILD_NUMBER
 - DEVICE_NAME
 - OS_VERSION
 - IP_ADDRESS
 - ACCESS_TOKEN
 */

import UIKit
import Foundation

//MARK:- Enums
enum LogType: String
{
    case tError = "[‼️]" // error
    case tInfo = "[ℹ️]" // info
    case tWarning = "[⚠️]" // warning
    case tSevere = "[🔥]" // severe
}

enum LogEnvironment
{
    case Developement
    case Testing
    case Production
    case Default
}

enum IssueLevel
{
    case Trivial
    case Normal
    case Minor
    case Major
    case Critical
    case Blocker
}

enum IssuePriority
{
    case P1
    case P2
    case P3
    case P4
    case P5
}

//MARK:- Log Functions
func LogClick(infoWithMessage message:String,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    if LogClicker.shared.printLogsInConsole == true
    {
        #if DEBUG
            print("\(Date().toString()) AKLogClick :\(LogType.tInfo.rawValue)[\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
        #endif
    }
}

func LogClick(warningWithMessage message:String, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        print("\(Date().toString()) AKLogClick :\(LogType.tWarning.rawValue)[\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
    #endif
}

func LogClick(errorWithMessage message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        print("\(Date().toString()) AKLogClick :\(LogType.tError.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
    #endif
}

func LogClick(exceptionWithMessage message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        print("\(Date().toString()) AKLogClick :\(LogType.tSevere.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
    #endif
}


//MARK:- Class AKLogClickManager
public class LogClicker
{
    //MARK: Public Variables
    public static let shared:LogClicker = LogClicker()
    public var printLogsInConsole:Bool = false
    public var saveLogsIntoFile:Bool = true
    
    //MARK: Private Variables
    private let projectName:String?
    private let bundleID:String?
    private let projectVersion:String?
    private let projectBuildNumber:String?
    private let deviceName:String?
    private let osVersion:String?
    private let osName:String?
    private let deviceIPAdrress:String?
    private let accessToken:String?
    
    
    init() {
        self.projectName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        self.bundleID = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
        self.projectVersion  = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        self.projectBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        self.deviceName = UIDevice.current.model
        self.osVersion = UIDevice.current.systemVersion
        self.osName = UIDevice.current.systemName
        self.deviceIPAdrress = UIDevice.getIP()!
        self.accessToken = ""
        
    }
    
    
    class func setup()
    {
        let PROJECT_NAME:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let BUNDLE_ID:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
        let PROJECT_VERSION:String  = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let PROJECT_BUILD_NUMBER:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let DEVICE_NAME:String = UIDevice.current.model
        let OS_VERSION:String = UIDevice.current.systemVersion
        let OS_NAME:String = UIDevice.current.systemName
        let IP_ADDRESS:String = UIDevice.getIP()!
        let ACCESS_TOKEN:String = ""
        
        print("\(Date().toString()) AKLogClick :Configuring..")
        print("\(Date().toString()) AKLogClick :PROJECT_NAME ->\(PROJECT_NAME)")
        print("\(Date().toString()) AKLogClick :BUNDLE_ID ->\(BUNDLE_ID)")
        print("\(Date().toString()) AKLogClick :PROJECT_VERSION ->\(PROJECT_VERSION)")
        print("\(Date().toString()) AKLogClick :PROJECT_BUILD_NUMBER ->\(PROJECT_BUILD_NUMBER)")
        print("\(Date().toString()) AKLogClick :DEVICE_NAME ->\(DEVICE_NAME)")
        print("\(Date().toString()) AKLogClick :OS_VERSION ->\(OS_VERSION)")
        print("\(Date().toString()) AKLogClick :OS_NAME ->\(OS_NAME)")
        print("\(Date().toString()) AKLogClick :IP_ADDRESS ->\(IP_ADDRESS)")
        print("\(Date().toString()) AKLogClick :ACCESS_TOKEN ->\(ACCESS_TOKEN)")
        print("\(Date().toString()) AKLogClick :printLogsInConsole ->\(LogClicker.shared.printLogsInConsole)")
    }
    
    class func addLogItem()
    {
        
    }
    
    //MARK: Class Functions
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}
