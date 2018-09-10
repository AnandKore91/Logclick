//
//  LogClickerManager.swift
//  LogClicker
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
func LogClick(info message:String,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.printLog("\(LogType.tInfo.rawValue)[\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
    #endif
}

func LogClick(warning message:String, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.printLog("\(LogType.tWarning.rawValue)[\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)")
    #endif
}

func LogClick(error:Error?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
    LogClicker.shared.printLog("\(LogType.tError.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(String(describing: error)):\(message)")
    #endif
}

func LogClick(exception:exception?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
    LogClicker.shared.printLog("\(LogType.tSevere.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(String(describing: exception)):\(message)")
    #endif
}


//MARK:- Class LogClickerManager
public class LogClicker
{
    //MARK: Shared instance
    public static var shared:LogClicker = LogClicker()
    
    //MARK: Public Variables
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
    private var logger:Logger = Logger()
    
    //MARK: Init
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
    
    //MARK: Device Info
    func deviceInfo()  {
        LogClicker.shared.printLog("PROJECT_NAME ->\(String(describing: self.projectName))")
        LogClicker.shared.printLog("BUNDLE_ID ->\(String(describing: self.bundleID))")
        LogClicker.shared.printLog("PROJECT_VERSION ->\(String(describing: self.projectVersion))")
        LogClicker.shared.printLog("PROJECT_BUILD_NUMBER ->\(String(describing: self.projectBuildNumber))")
        LogClicker.shared.printLog("DEVICE_NAME ->\(String(describing: self.deviceName))")
        LogClicker.shared.printLog("OS_VERSION ->\(String(describing: self.osVersion))")
        LogClicker.shared.printLog("OS_NAME ->\(String(describing: self.osName))")
        LogClicker.shared.printLog("IP_ADDRESS ->\(String(describing: self.deviceIPAdrress))")
        LogClicker.shared.printLog("ACCESS_TOKEN ->\(String(describing: self.accessToken))")
    }
    
    
    public func printLog(_ logMsg:String){
        self.logger.write("\(Date().toString()) LogClicker :\(logMsg)")
    }
    
    
    
    //MARK: Class Functions
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

//MARK:- Structs
struct Logger: TextOutputStream {
    
    //--- Appends the given string to the stream.
    mutating func write(_ string: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        let log = documentDirectoryPath.appendingPathComponent("LogClicker.txt")
        
        print(string)
        let msg = "\(string)\n"
        do {
            let handle = try FileHandle(forWritingTo: log)
            handle.seekToEndOfFile()
            handle.write(msg.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            print(error.localizedDescription == "The file “LogClicker.txt” doesn’t exist." ? "": error.localizedDescription)
            do {
                try msg.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
}
