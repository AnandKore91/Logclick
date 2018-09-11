//
//  LogClickerManager.swift
//  LogClicker
//
//  Created by Anand Kore on 25/10/17.
//  Copyright © 2017 Anand Kore. All rights reserved.
//

/*
 || ITEMS Table ||
 ITEM     //--- Unique Log Messages
 DATE
 FIRST_SEEN
 LAST_SEEN
 TOTAL_OCCURRENCES
 IPs_AFFECTED
 LOG_TYPE
 LEVEL
 PRIORITY
 ENVIRONMENT
 PROJECT_NAME
 BUNDLE_ID
 PROJECT_VERSION
 PROJECT_BUILD_NUMBER
 DEVICE_NAME
 OS_VERSION
 IP_ADDRESS
 ACCESS_TOKEN
 */

import UIKit
import Foundation
import FMDB

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
    private let database:FMDatabase?
    
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
        
        
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("LogClicker.sqlite")
        
        self.database = FMDatabase(url: fileURL)
        self.createTableIfNotExist()
    }
    
    //MARK: Utility Functions
    
    private func log(exception:exception?,error:Error?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
    {
        //LogClicker.shared.printLog("\(LogType.tSevere.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(String(describing: exception)):\(message)")
        
        
    }
    
    public func printLog(_ logMsg:String){
        self.logger.write("\(Date().toString()) LogClicker :\(logMsg)")
    }
    
    public func deviceInfo() -> (
        projectName:String,
        bundleID:String,
        projectVersion:String,
        projectBuildNumber:String,
        deviceName:String,
        osVersion:String,
        osName:String,
        deviceIPAdrress:String)
    {
//        LogClicker.shared.printLog("PROJECT_NAME ->\(String(describing: self.projectName))")
//        LogClicker.shared.printLog("BUNDLE_ID ->\(String(describing: self.bundleID))")
//        LogClicker.shared.printLog("PROJECT_VERSION ->\(String(describing: self.projectVersion))")
//        LogClicker.shared.printLog("PROJECT_BUILD_NUMBER ->\(String(describing: self.projectBuildNumber))")
//        LogClicker.shared.printLog("DEVICE_NAME ->\(String(describing: self.deviceName))")
//        LogClicker.shared.printLog("OS_VERSION ->\(String(describing: self.osVersion))")
//        LogClicker.shared.printLog("OS_NAME ->\(String(describing: self.osName))")
//        LogClicker.shared.printLog("IP_ADDRESS ->\(String(describing: self.deviceIPAdrress))")
//        LogClicker.shared.printLog("ACCESS_TOKEN ->\(String(describing: self.accessToken))")
        
        return (String(describing: self.projectName),
                String(describing: self.bundleID),
                String(describing: self.projectVersion),
                String(describing: self.projectBuildNumber),
                String(describing: self.deviceName),
                String(describing: self.osVersion),
                String(describing: self.osName),
                String(describing: self.deviceIPAdrress))
        
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
 
    //MARK:- DB Function
    private func createTableIfNotExist(){
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do {
                
                let create_tbl_query = "CREATE  TABLE tblLogClicker(ID INTEGER PRIMARY KEY autoincrement, LOG_DATE text, ITEM text, LOG_TYPE text, LEVEL text, PRIORITY text, ENVIRONMENT text, DeviceID text, DEVICE_NAME text, OS_VERSION text, IP_ADDRESS text, ACCESS_TOKEN text, BUNDLE_ID text, PROJECT_NAME text, PROJECT_VERSION text, PROJECT_BUILD_NUMBER text)"
                try database.executeUpdate(create_tbl_query, values: nil)
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    private func updateLog(msg:String,type:String = "ℹ️", level:String = "Normal", priority:String = "No Priority", environment:String = "Default"){
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do {
                try database.executeUpdate("INSERT INTO tblLogClicker(LOG_DATE, ITEM, LOG_TYPE, LEVEL, PRIORITY, ENVIRONMENT, DeviceID, DEVICE_NAME, OS_VERSION, IP_ADDRESS, ACCESS_TOKEN, BUNDLE_ID, PROJECT_NAME, PROJECT_VERSION, PROJECT_BUILD_NUMBER) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", values: [Date().toString(),msg,type,level,priority,environment,UIDevice.current.identifierForVendor!,self.deviceName!,self.osName!,self.deviceIPAdrress!,self.accessToken!,self.bundleID!,self.projectName!,self.projectVersion!,self.projectBuildNumber!])
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            
            database.close()
        }
        
    }
    private func fetchData(query:String)
    {
        var arrResults = [[String:Any]]()
        if let database = self.database
        {
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do{
                let rs = try database.executeQuery(query, values: nil)
                for index in 0...rs.columnCount
                {
                    let columnName:String = rs.columnName(for: index)!
                    let value = rs.string(forColumn: columnName)
                    
                    arrResults.append([columnName:value ?? ""])
                }
            }
            catch {
                print("Exception")
            }
            database.close()
        }
        
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
