# Roadmap

## Functions:
- Log(info: "This is informations log.")
- Log(warning: "This is Warning log.")
- Log(error: nil, message: "Error with optional error.")
- Log(exception: nil, message: "This is exceptions log.")
- Log(error: nil, message: "This is error with more details", level: .Major, priority: .P3)
- Log(exception: nil, message: "This is exception with more details", level: .Blocker, priority: .P1)

## Logs Store Location
- Text File
- Database
- Print only
- Print and Text File
- Print and Database
- Text file and Database

## Features:
- Export logs from date - to date .  
- Upload report file to URL. (Adding soon)
- Reset log history.
- Reset logs from date: to date:
- Max File Size (Adding soon)
- Reset after every 7 days (Adding soon)
- File name (Adding soon)

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

