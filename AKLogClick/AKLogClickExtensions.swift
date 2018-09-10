//
//  AKLogClickExtensions.swift
//  AKLogClick
//
//  Created by Anand Kore on 26/10/17.
//  Copyright © 2017 Anand Kore. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice
{
    class func getIP()-> String?
    {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                    
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    
}


//MARK: Date ex
extension Date
{
    func toString() -> String
    {
        var dateFormat = "yyyy-MM-dd hh:mm:ss" // Use your own
        var dateFormatter: DateFormatter
        {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            return formatter
        }
        
        return dateFormatter.string(from: self as Date)
    }
    
    // 1. The date formatter
    
}
