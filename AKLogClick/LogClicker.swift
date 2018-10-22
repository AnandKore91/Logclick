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


//MARK: Constants
private let LOG_TEXT_FILE_NAME = "LogClicker.txt"
private let LOG_DATABASE_FILE_NAME = "LogClicker.sqlite"

//MARK:- Log Functions

/*!
 * @discussion Use this function to print info log.
 * @param Log message.
 * @return nil
 */
func Log(info message:String,fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: nil, type: .tInfo , message: message, level: IssueLevel.Trivial.rawValue, priority: IssuePriority.NoPriority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    #endif
}

/*!
 * @discussion Use this function to print warning log.
 * @param Warning message.
 * @return nil
 */
func Log(warning message:String, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: nil, type: .tWarning , message: message, level: IssueLevel.Normal.rawValue, priority: IssuePriority.NoPriority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    
    #endif
}

/*!
 * @discussion Use this function to print error log.
 * @param Error
 * @param Error message
 * @param IssueLevel Level
 * @param IssuePriority Level
 * @return nil
 */
func Log(error:Error?, message:String,level:IssueLevel = IssueLevel.Normal,priority:IssuePriority = IssuePriority.P5, fileName: String = #file, line: Int = #line, column: Int = #column,funcName: String = #function)
{
    #if DEBUG
        LogClicker.shared.log(exception: nil, error: error, type: .tError , message: message, level: level.rawValue, priority: priority.rawValue, environment: LogEnvironment.Default.rawValue, fileName: fileName, line: line, column: column, funcName: funcName)
    
    #endif
}

/*!
 * @discussion Use this function to print exception log.
 * @param Exception
 * @param Exception message
 * @param IssueLevel Level
 * @param IssuePriority Level
 * @return nil
 */
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
    /** Logs location. */
    public var logsStoreLocation:LogsStoreLocation = .database
    
    /** Maximum logs file size. */
    public var maxDBFileSize:Double{
        set(newMaxDBFileSize){
            if newMaxDBFileSize > 0 {
                UserDefaults.standard.set(newMaxDBFileSize, forKey: "MAX_FILE_SIZE")
                UserDefaults.standard.synchronize()
                
                _ = LogClicker.shared.deleteLogFile(greaterThan: newMaxDBFileSize)
            }
        }
        get{
            if let maxSize:Double = UserDefaults.standard.value(forKey: "MAX_FILE_SIZE") as? Double {
                return maxSize
            }
            else{
                UserDefaults.standard.set(5000000, forKey: "MAX_FILE_SIZE") //-- Default 5 MB
                UserDefaults.standard.synchronize()
            }
            return 5000000
        }
    }
    
    public var currentLogDBFileSize:Double{
        get{
            return  Utility.getFileSizeInMB(url: DB_LOG_FILE_URL)
        }
    }
    public var currentLogTextFileSize:Double{
        get{
            return  Utility.getFileSizeInMB(url: TEXT_LOG_FILE_URL)
        }
    }
    
    
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
    private var database:FMDatabase?
    
    public var TEXT_LOG_FILE_URL:URL?{
        get{
            let fileURL = try? FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(LOG_TEXT_FILE_NAME)
            if let fileURL = fileURL {
                return fileURL
            }
            else{
                return nil
            }
        }
    }
    
    public var DB_LOG_FILE_URL:URL?{
        get{
            let fileURL = try? FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(LOG_DATABASE_FILE_NAME)
            if let fileURL = fileURL {
                return fileURL
            }
            else{
                return nil
            }
        }
    }
    
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
        
        //--- Validate max log file size.
        if let maxSize:Double = UserDefaults.standard.value(forKey: "MAX_FILE_SIZE") as? Double {
            let isDeleted:Bool = deleteLogFile(greaterThan: maxSize)
            if isDeleted{
                if let fileURL = LogClicker.getFileURLfor(fileName: LOG_DATABASE_FILE_NAME, createIfNotExist: true){
                    self.database = FMDatabase(url: fileURL)
                    self.createTableIfNotExist()
                }
                else{
                    print("Failed to create file.")
                    self.database  = FMDatabase()
                }
            }
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
    
    //MARK:- Logs Sharing Function
    fileprivate func upload(logFile:URL, uploadURL:URL){
        
    }
    
    //MARK:- Utility Functions
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
        return (String(describing: self.projectName),
                String(describing: self.bundleID),
                String(describing: self.projectVersion),
                String(describing: self.projectBuildNumber),
                String(describing: self.deviceName),
                String(describing: self.osVersion),
                String(describing: self.osName),
                String(describing: self.deviceIPAdrress))
        
    }
    
    fileprivate class func sourceFileName(filePath: String) -> String {
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

    fileprivate func deleteLogFile(greaterThan maxSize:Double) -> Bool{
        if Utility.getFileSizeInMB(url: TEXT_LOG_FILE_URL) > maxSize{
            return Utility.deleteFile(url: TEXT_LOG_FILE_URL)
        }
        
        print("\(Utility.getFileSizeInMB(url: DB_LOG_FILE_URL))")
        if Utility.getFileSizeInMB(url: DB_LOG_FILE_URL) > maxSize{
            return Utility.deleteFile(url: DB_LOG_FILE_URL)
        }
        return false
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

//MARK:- Resetter Functions
extension LogClicker{
    public func resetLogs(location:LogsStoreLocation)->Bool{
        switch location {
        case .database:
            if let fileURL:URL = DB_LOG_FILE_URL{
                do{
                    try FileManager.default.removeItem(at: fileURL)
                }
                catch let error{
                    print("Unable to reset logs.\(error.localizedDescription)")
                    return false
                }
            }
            return true
        case .textFile:
            if let fileURL:URL = TEXT_LOG_FILE_URL{
                do{
                    try FileManager.default.removeItem(at: fileURL)
                }
                catch{
                    print("Unable to reset logs.")
                    return false
                }
            }
            return true
        case .printOnly: break
        case .printAndTextFile: break
        case .printAndDatabase: break
        case .textFileAndDatabase: break
        }
        return false
    }
    
    public func resetLogs(fromDate:Date, toDate:Date, location:LogsStoreLocation)->Bool{
        return executeUpdate(query: "DELETE FROM tblLogClicker WHERE LOG_DATE BETWEEN '\(fromDate.toString())'  AND '\(toDate.toString())'")
    }
    
    public func resetLogs(olderThan date:Date)->Bool{
        return executeUpdate(query: "DELETE FROM tblLogClicker WHERE LOG_DATE > '\(date.toString())'")
    }
}

//MARK:- Logs Getters
extension LogClicker{
    public func getAllLogs()-> [[String:Any]]{
        return fetchData(query: "SELECT * FROM tblLogClicker")
    }
    
    public func getLogs(whereKeys:[WhereKey:String]?, limit:Int?)->[[String:Any]]{
        var whereKeyArray = [String]()
        var whereKeyString:String?
        if let whereKeys = whereKeys{
            for (key, value) in whereKeys{
                whereKeyArray.append("\(key.rawValue) = '\(value)'")
            }
            whereKeyString = "SELECT * FROM tblLogClicker WHERE \(whereKeyArray.joined(separator: " AND "))"
        }
        else{
            whereKeyString = "SELECT * FROM tblLogClicker"
        }
       
        if let limit = limit, var whereKeyString = whereKeyString{
            whereKeyString = "\(whereKeyString) LIMIT \(limit)"
        }
        
        print("\(String(describing: whereKeyString))")
        
        let result = fetchData(query: whereKeyString ?? "SELECT * FROM tblLogClicker")
        return result
    }
    
    public func getLogs(fromDate:Date, toDate:Date, location:LogsStoreLocation)-> [[String:Any]]{
        return fetchData(query: "SELECT * FROM tblLogClicker WHERE LOG_DATE BETWEEN '\(fromDate.toString())'  AND '\(toDate.toString())'")
    }
    
    //MARK: First and Last Seen
    public func firstSeen(whereKeys:[WhereKey:String]!)->[[String:Any]]?{
        return seen(whereKeys: whereKeys, first: true)
    }
    
    public func lastSeen(whereKeys:[WhereKey:String]!)->[[String:Any]]?{
        return seen(whereKeys: whereKeys, first: false)
    }
    
    private func seen(whereKeys:[WhereKey:String]!, first:Bool)->[[String:Any]]?{
        var whereKeyArray = [String]()
        var whereKeyString:String?
        if let whereKeys = whereKeys{
            for (key, value) in whereKeys{
                whereKeyArray.append("\(key.rawValue) = '\(value)'")
            }
            whereKeyString = "SELECT * FROM tblLogClicker WHERE \(whereKeyArray.joined(separator: " AND "))"
        }
        else{
            whereKeyString = "SELECT * FROM tblLogClicker"
        }
        
        if var whereKeyString = whereKeyString{
            print("\(whereKeyString)")
            
            if first {
                whereKeyString = "\(whereKeyString) ORDER BY LOG_DATE LIMIT 1"
            }
            else{
                whereKeyString = "\(whereKeyString) ORDER BY LOG_DATE DESC LIMIT 1"
            }
            
            let result = fetchData(query: whereKeyString)
            return result
        }
        
        return nil
    }
    
}

//MARK:- DB Function
extension LogClicker{
    fileprivate func createTableIfNotExist(){
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return
            }
            
            do {
                let create_tbl_query = "CREATE TABLE IF NOT EXISTS tblLogClicker(ID INTEGER PRIMARY KEY autoincrement, LOG_DATE datetime, FILE_NAME text, ITEM text, LOG_TYPE text, LEVEL text, PRIORITY text, ENVIRONMENT text, DeviceID text, DEVICE_NAME text, OS_VERSION text, IP_ADDRESS text, ACCESS_TOKEN text, BUNDLE_ID text, PROJECT_NAME text, PROJECT_VERSION text, PROJECT_BUILD_NUMBER text)"
                try database.executeUpdate(create_tbl_query, values: nil)
            } catch {
                print("failed: \(error.localizedDescription)")
            }
            database.close()
        }
    }
    
    fileprivate func updateLog(msg:String,fileName:String, type:String = "ℹ️", level:String = "Normal", priority:String = "No Priority", environment:String = "Default"){
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
    fileprivate func fetchData(query:String) ->[[String : Any]]
    {
        var arrResults = [[String:Any]]()
        if let database = self.database
        {
            guard database.open() else {
                print("Unable to open database")
                return arrResults
            }
            
            do{
                let rs = try database.executeQuery(query, values: nil)
                while rs.next() {
                    arrResults.append(rs.resultDictionary as! [String : Any])
                }
            }
            catch {
                print("Exception")
            }
            database.close()
        }
        print(arrResults)
        return arrResults
    }
    
    fileprivate func executeUpdate(query:String)->Bool{
        if let database = self.database{
            guard database.open() else {
                print("Unable to open database")
                return false
            }
            
            do {
                try database.executeUpdate(query, values: nil)
            } catch {
                print("failed: \(error.localizedDescription)")
                return false
            }
            database.close()
        }
        return true
    }
}
