![Logclick](https://github.com/AnandKore91/LogClick/blob/master/logclick.png)

## Functions:
- `Log(info: "This is informations log.")`
- `Log(warning: "This is Warning log.")`
- `Log(error: nil, message: "Error with optional error.")`
- `Log(exception: nil, message: "This is exceptions log.")`
- `Log(error: nil, message: "This is error with more details", level: .Major, priority: .P3)`
- `Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)`

## Logs Store Location
- [x] Text File
- [x] Database
- [x] Print only
- [x] Print and Text File
- [x] Print and Database
- [x] Text file and Database

Example: `LogClicker.shared.logsStoreLocation = .printAndDatabase`

## Log Getters
- Get logs from date - to date .  [Returns array of dictionary.]
`LogClicker.shared.getLogs(fromDate: <#T##Date#>, toDate: <#T##Date#>, location: <#T##LogsStoreLocation#>)`

- Get logs with where clause.
`LogClicker.shared.getLogs(whereKeys: [WhereKey.LEVEL : IssueLevel.Blocker.rawValue, WhereKey.OS_VERSION:"11.4.1"])`

- Get all logs.
`LogClicker.shared.getAllLogs()`

## Logs DB Management:
- [x] Reset log history.
`LogClicker.shared.resetLogs(location: <#T##LogsStoreLocation#>)`

- [x] Reset logs from date: to date:
`LogClicker.shared.resetLogs(fromDate: <#T##Date#>, toDate: <#T##Date#>, location: <#T##LogsStoreLocation#>)`

- [ ] Max File Size (Adding soon)
- [ ] Reset after every 7 days (Adding soon)

## Sharing Logs
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


## Filters:
- [x] FirstSeen
- [x] LastSeen
- [ ] TotalOccurrences:level:priority:type
- [ ] UniqueIPsAffected

## Device Informations:
- [x] PROJECT NAME
- [x] BUNDLE ID
- [x] PROJECT VERSION
- [x] PROJECT BUILD NUMBER
- [x] DEVICE NAME
- [x] OS VERSION
- [x] IP ADDRESS
- [x] ACCESS TOKEN


## Log Type:
- [x] Info
- [x] Warning
- [x] Error
- [x] Exception

## Log Level:
- [x] Trivial
- [x] Normal
- [x] Minor
- [x] Major
- [x] Critical
- [x] Blocker

## Priority:
- [x] P1
- [x] P2
- [x] P3
- [x] P4
- [x] P5
