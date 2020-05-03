//
//  TimeFormatter.swift
//  Snip
//
//  Created by Amitabha Saha on 02/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation

class TimeFormatter {
    static func getCurrentLocalTimeStamp() -> String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var timest = formatter.string(from: Date())
        timest = timest.replacingOccurrences(of: " ", with: "T")
        return timest + "Z"
    }
}
