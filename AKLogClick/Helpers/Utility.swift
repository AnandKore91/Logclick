//
//  Utility.swift
//  AKLogClick
//
//  Created by Anand Kore on 22/10/18.
//  Copyright © 2018 Anand Kore. All rights reserved.
//

import UIKit

class Utility: NSObject {
    class func getFileSizeInMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    class func deleteFile(url:URL?)-> Bool{
        if let url = url{
            do{
                try FileManager.default.removeItem(at: url)
            }
            catch let error{
                print("Unable to reset logs.\(error.localizedDescription)")
                return false
            }
            return true
        }
        return false
    }
}


//MARK:- Enums
/// LogType enum.
public enum LogType: String
{
    /// Enum description
    /// - ‼️: Error type log
    /// - ℹ️: Info type log
    /// - ⚠️: Warning type log
    /// - 🔥: Severe type log
    
    case tError = "[Error ‼️]"
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

public enum WhereKey:String{
    case LOG_DATE = "LOG_DATE"
    case LOG_TYPE = "LOG_TYPE"
    case LEVEL = "LEVEL"
    case PRIORITY = "PRIORITY"
    case FILE_NAME = "FILE_NAME"
    case LOG = "ITEM"
    case ENVIRONMENT = "ENVIRONMENT"
    case OS_VERSION = "OS_VERSION"
    case BUNDLE_ID = "BUNDLE_ID"
    case PROJECT_NAME = "PROJECT_NAME"
    case PROJECT_VERSION = "PROJECT_VERSION"
    case PROJECT_BUILD_NUMBER = "PROJECT_BUILD_NUMBER"
}
