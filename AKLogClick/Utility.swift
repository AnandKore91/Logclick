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
