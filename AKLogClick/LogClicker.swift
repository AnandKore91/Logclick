//
//  LogClickerManager.swift
//  LogClicker
//
//  Created by Anand Kore on 25/10/17.
//  Copyright © 2017 Anand Kore. All rights reserved.
//

import UIKit
import Foundation
import FMDB

//MARK:- Enums
public enum LogType: String
{
    case tError = "[Error ‼️]" // error
    case tInfo = "[Info ℹ️]" // info
    case tWarning = "[Warning ⚠️]" // warning
    case tSevere = "[Severe 🔥]" // severe
}

public enum LogEnvironment:String
{
    case Developement = "Developement"
    case Testing = "Testing"
    case Production = "Production"
    case Default = "Default"
}

public enum IssueLevel:String
{
    case Trivial = "Trivial"
    case Normal = "Normal"
    case Minor = "Minor"
    case Major = "Major"
    case Critical = "Critical"
    case Blocker = "Blocker"
}

public enum IssuePriority:String
{
    case P1 = "P1"
    case P2 = "P2"
    case P3 = "P3"
    case P4 = "P4"
    case P5 = "P5"
    case NoPriority = "No Priority"
}

public enum LogsStoreLocation:String
{
    case textFile = "textFile"
    case database = "database"
    case printOnly = "printOnly"
    case printAndTextFile = "printAndTextFile"
    case printAndDatabase = "printAndDatabase"
    case textFileAndDatabase = "textFileAndDatabase"
}

//MARK: Constants
private let LOG_TEXT_FILE_NAME = "LogClicker.txt"
private let LOG_DATABASE_FILE_NAME = "LogClicker.sqlite"

//MARK:- Log Functions
func Log(info message:String,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: nil, type: .tInfo , message: message, level: IssueLevel.Trivial.rawValue, priority: IssuePriority.NoPriority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    #endif
}

func Log(warning message:String, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: nil, type: .tWarning , message: message, level: IssueLevel.Normal.rawValue, priority: IssuePriority.NoPriority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    
    #endif
}

func Log(error:Error?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: error, type: .tError , message: message, level: level.rawValue, priority: priority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    
    #endif
}

func Log(exception:exception?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: exception, error: nil, type: .tSevere, message: message, level: level.rawValue, priority: priority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    #endif
}


//MARK:- Class LogClickerManager
public class LogClicker
{
    //MARK: Shared instance
    public static var shared:LogClicker = LogClicker()
    
    //MARK: Public Variables
    public var logsStoreLocation:LogsStoreLocation = .database
    
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
    
    //MARK:- Init
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
        
        if let fileURL = LogClicker.getFileURLfor(fileName: LOG_DATABASE_FILE_NAME, createIfNotExist: true){
            self.database = FMDatabase(url: fileURL)
            self.createTableIfNotExist()
        }
        else{
            print("Failed to create file.")
            self.database  = FMDatabase()
        }
    }
    
    fileprivate func log(exception:exception?,error:Error?, type:LogType, message:String,level:String = IssueLevel.Normal.rawValue, priority:String = IssuePriority.P5.rawValue, environment:String = LogEnvironment.Default.rawValue,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
    {
        let msg = "\(Date().toString()) \(type.rawValue)[\(level)][\(priority)][\(fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!)]:\(line) \(column) \(funcName) -> \(message)"
        
        //--- Validate operation.
        switch self.logsStoreLocation
        {
            case .printOnly:
                print(msg)
                break
            case .database:
                self.updateLog(msg: message, fileName: (fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!), type: type.rawValue, level: level, priority: priority, environment: environment)
                break
            case .textFile:
                self.logger.write("\(Date().toString()) LogClicker :\(msg)")
                break
            case .printAndTextFile:
                print(msg)
                self.logger.write("\(Date().toString()) LogClicker :\(msg)")
                break
            case .printAndDatabase:
                print(msg)
                self.updateLog(msg: message, fileName: (fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!), type: type.rawValue, level: level, priority: priority, environment: environment)
                break
            case .textFileAndDatabase:
                self.logger.write("\(Date().toString()) LogClicker :\(msg)")
                self.updateLog(msg: message, fileName: (fileName.components(separatedBy: "/").isEmpty ? "" : fileName.components(separatedBy: "/").last!), type: type.rawValue, level: level, priority: priority, environment: environment)
                break
            
        }
    
        
    }
    
    //MARK:- DB Function
    private func createTableIfNotExist(){
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do {
                let create_tbl_query = "CREATE TABLE IF NOT EXISTS tblLogClicker(ID INTEGER PRIMARY KEY autoincrement, LOG_DATE text, FILE_NAME text, ITEM text, LOG_TYPE text, LEVEL text, PRIORITY text, ENVIRONMENT text, DeviceID text, DEVICE_NAME text, OS_VERSION text, IP_ADDRESS text, ACCESS_TOKEN text, BUNDLE_ID text, PROJECT_NAME text, PROJECT_VERSION text, PROJECT_BUILD_NUMBER text)"
                try database.executeUpdate(create_tbl_query, values: nil)
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    private func updateLog(msg:String,fileName:String, type:String = "ℹ️", level:String = "Normal", priority:String = "No Priority", environment:String = "Default"){
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do {
                try database.executeUpdate("INSERT INTO tblLogClicker(LOG_DATE, FILE_NAME, ITEM, LOG_TYPE, LEVEL, PRIORITY, ENVIRONMENT, DeviceID, DEVICE_NAME, OS_VERSION, IP_ADDRESS, ACCESS_TOKEN, BUNDLE_ID, PROJECT_NAME, PROJECT_VERSION, PROJECT_BUILD_NUMBER) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", values: [Date().toString(),fileName,msg,type,level,priority,environment,UIDevice.current.identifierForVendor!,self.deviceName!,self.osVersion!,self.deviceIPAdrress!,self.accessToken!,self.bundleID!,self.projectName!,self.projectVersion!,self.projectBuildNumber!])
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
    
    //MARK: Clearing Functions
    public func resetLogs(location:LogsStoreLocation)->Bool{
        var status = false
        
        
        
        
        return status
    }
    
    //MARK: Utility Functions
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
    
    fileprivate class func getFileURLfor(fileName:String, createIfNotExist:Bool)->URL?{
        let fileURL = try? FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: createIfNotExist)
            .appendingPathComponent(fileName)
        if let fileURL = fileURL {
            return fileURL
        }
        else{
            return nil
        }
    }
    
    private class func removeFile(filename:String, path:String)->Bool{
        var status = false
        
        if let fileURL = LogClicker.getFileURLfor(fileName: filename, createIfNotExist: false){
            
        }
        
        
        
        return status
    }
    
}

//MARK:- Structs
struct Logger: TextOutputStream {
    
    //--- Appends the given string to the stream.
    mutating func write(_ string: String) {
        if let fileURL = LogClicker.getFileURLfor(fileName: LOG_TEXT_FILE_NAME, createIfNotExist: true){
            print(string)
            let msg = "\(string)\n"
            do {
                let handle = try FileHandle(forWritingTo: fileURL)
                handle.seekToEndOfFile()
                handle.write(msg.data(using: .utf8)!)
                handle.closeFile()
            } catch {
                print(error.localizedDescription == "The file “LogClicker.txt” doesn’t exist." ? "": error.localizedDescription)
                do {
                    try msg.data(using: .utf8)?.write(to: fileURL)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        else{
            print("Failed to create file.")
            
        }
        
        
        
        
    }
    
}
