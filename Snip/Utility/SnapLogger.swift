//
//  SnapLogger.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation

class Logger {
    
    static func log(_ message: String, file: NSString = #file, line: Int = #line, functionName: String = #function) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print("[\(file.lastPathComponent):\(line)]: \(message)")
    }
}
