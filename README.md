# LogClick

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

## Features:
- [ ] Upload report file to URL. (Adding soon)
- [x] Reset log history.
`LogClicker.shared.resetLogs(location: <#T##LogsStoreLocation#>)`

- [x] Reset logs from date: to date:
`LogClicker.shared.resetLogs(fromDate: <#T##Date#>, toDate: <#T##Date#>, location: <#T##LogsStoreLocation#>)`

- [ ] Max File Size (Adding soon)
- [ ] Reset after every 7 days (Adding soon)
- [ ] File name (Adding soon)

## Filters:
- FirstSeen
- LastSeen
- TotalOccurrences:level:priority:type
- UniqueIPsAffected

## Device Informations:
- PROJECT NAME
- BUNDLE ID
- PROJECT VERSION
- PROJECT BUILD NUMBER
- DEVICE NAME
- OS VERSION
- IP ADDRESS
- ACCESS TOKEN


## Log Type:
- Info
- Warning
- Error
- Exception

## Log Level:
- Trivial
- Normal
- Minor
- Major
- Critical
- Blocker

## Priority:
- P1
- P2
- P3
- P4
- P5
