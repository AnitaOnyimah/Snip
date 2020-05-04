//
//  SnapLogger.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation

class Logger {
    
    static func log(_ message: String, file: NSString = #file, line: Int = #line, functionName: String = #function) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print("[\(file.lastPathComponent):\(line)]: \(message)")
    }
}
