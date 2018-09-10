# Roadmap

## Device Informations:
- PROJECT_NAME
- BUNDLE_ID
- PROJECT_VERSION
- PROJECT_BUILD_NUMBER
- DEVICE_NAME
- OS_VERSION
- IP_ADDRESS
- ACCESS_TOKEN
- printLogsInConsole:BOOL


## Functions:
- LogClick(infoWithWithMessage: <#T##String#>)
- LogClick(warningWithMessage: <#T##String#>)
- LogClick(errorWithMessage: <#T##String#>)
- LogClick(exceptionWithMessage: <#T##String#>)
- LogClick(errorWithMessage: <#T##String#>, level: <#T##IssueLevel#>, priority: <#T##IssuePriority#>)
- LogClick(exceptionWithMessage: <#T##String#>, level: <#T##IssueLevel#>, priority: <#T##IssuePriority#>)


## Features:
- Shake to export report.  
- Upload report file to URL.
- Print logs in console.
- Reset log history.
- Reset logs from date: to date:


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


## Filters:
- FirstSeen
- LastSeen
- TotalOccurrences:level:priority:type
- UniqueIPsAffected
