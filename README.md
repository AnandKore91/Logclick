![Logclick](https://github.com/AnandKore91/LogClick/blob/master/logclick.png)

## Functions:
*Quickly spot :eyes: problems at runtime in the Xcode console, where log messages are color :rainbow: coded by severity:*

- :information_source: `Log(info: "This is informations log.")`
- :warning: `Log(warning: "This is Warning log.")`
- :heavy_exclamation_mark: `Log(error: nil, message: "Error with optional error.")`
- :bangbang: `Log(exception: nil, message: "This is exceptions log.")`
- :heavy_exclamation_mark: `Log(error: nil, message: "This is error with more details", level: .Major, priority: .P3)`
- :bangbang: `Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)`

Sample Output:
```
[["LOG_DATE": 2018-10-295 14:10:99.997, "BUNDLE_ID": com.sample.MyApp, "ENVIRONMENT": Default, "LEVEL": Blocker, "ID": 16, "LOG_TYPE": [Severe 🔥], "PROJECT_VERSION": 1.0, "OS_VERSION": 12.0, "ITEM": This is exception with more details, "DEVICE_NAME": iPhone, "ACCESS_TOKEN": , "PRIORITY": P1, "IP_ADDRESS": 10.0.1.13, "PROJECT_BUILD_NUMBER": 1, "PROJECT_NAME": MyApp, "DeviceID": 52193994-2CAA-4C6B-8F92-72B7538607EF, "FILE_NAME": ViewController.swift]]
```

## Logs Store Location :cloud:
*You can store logs into the database, textfile or you can choose print only or both.*

- [x] :bookmark_tabs: Text File
- [x] :file_folder: Database
- [x] Print only
- [x] Print and Text File
- [x] Print and Database
- [x] Text file and Database

Example: 
```
LogClicker.shared.logsStoreLocation = .printAndDatabase
```

## Log Getters
*Fetch all logs, fetch between dates or even you can fetch with `where` clauses.*

- :calendar: Get logs from date - to date .  [Returns array of dictionary.]
```
LogClicker.shared.getLogs(fromDate: <#T##Date#>, toDate: <#T##Date#>, location: <#T##LogsStoreLocation#>)
```

- :mag: Get logs with where clause.
```
LogClicker.shared.getLogs(whereKeys: [WhereKey.LEVEL : IssueLevel.Blocker.rawValue, WhereKey.OS_VERSION:"11.4.1"])
```

- :mag: Get all logs.
`LogClicker.shared.getAllLogs()`


## Logs DB Management: :construction_worker:
*Manage the log database with helper functions. You can reset complete logs, reset logs into between two dates or logs older than specific date.*

- [x] Reset log history.
```
LogClicker.shared.resetLogs(location: <#T##LogsStoreLocation#>)
```

- [x] Reset logs from date: to date:
```
LogClicker.shared.resetLogs(fromDate: <#T##Date#>, toDate: <#T##Date#>, location: <#T##LogsStoreLocation#>)
```

- [x] Reset logs older than date.
```
if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()){
    let reseted:Bool =  LogClicker.shared.resetLogs(olderThan: yesterday)
    print(reseted)
}
```

- [x] Max File Size (Setter): 
*Set maximum log file size.* 
*LogClicker will automatically deletes the log file if `LogClicker.shared.currentLogDBFileSize` exceeds `LogClicker.shared.maxDBFileSize`.*
```
LogClicker.shared.maxDBFileSize =  5000000 //--- 5 MB
```

- [x] Current log file size. 
*Get the current log file size.*
```
let currentLogDBFileSize:Double = LogClicker.shared.currentLogDBFileSize //-- For DB
let currentLogTextFileSize:Double = LogClicker.shared.currentLogTextFileSize //-- For TextFile
```

## Sharing Logs
*Share log file with developer. User following getters to get log file URL.*
- [x] Get logs database
```
if let db_url = LogClicker.shared.DB_LOG_FILE_URL{
    print(db_url)
}
```
- [x] Get logs textfile
```
if let db_url = LogClicker.shared.TEXT_LOG_FILE_URL{
    print(db_url)
}
```
    
- [ ] Upload report file to URL. (Adding soon)
- [ ] File name (Adding soon)


## Filters: :mag:
*Best thing of Logclicker is that you can see when the specific issue was first seen or last seen with super easy functions.*

- [x] FirstSeen
```
print(LogClicker.shared.firstSeen(whereKeys: [WhereKey.LEVEL: IssueLevel.Blocker.rawValue]) ?? "")
print(LogClicker.shared.firstSeen(whereKeys: [WhereKey.LOG_TYPE: LogType.tSevere.rawValue]) ?? "")
```

- [x] LastSeen
```
print(LogClicker.shared.lastSeen(whereKeys: [WhereKey.LEVEL: IssueLevel.Blocker.rawValue]) ?? "")
print(LogClicker.shared.lastSeen(whereKeys: [WhereKey.LOG_TYPE: LogType.tSevere.rawValue]) ?? "")
```

- [ ] TotalOccurrences:level:priority:type
- [ ] UniqueIPsAffected

## Device Informations: :information_source:
*Get device information, on which logs are recorded with full details.*

- [x] PROJECT NAME
- [x] BUNDLE ID
- [x] PROJECT VERSION
- [x] PROJECT BUILD NUMBER
- [x] DEVICE NAME
- [x] OS VERSION
- [x] IP ADDRESS
- [x] ACCESS TOKEN


## Log Type:
*Log by type.*

- [x] Info
- [x] Warning
- [x] Error
- [x] Exception

## Log Level:
*Log  by level*

- [x] Trivial
- [x] Normal
- [x] Minor
- [x] Major
- [x] Critical
- [x] Blocker

## Priority:
*Sort  by priorities.*

- [x] P1
- [x] P2
- [x] P3
- [x] P4
- [x] P5
