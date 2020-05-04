//
//  TimeFormatter.swift
//  Snip
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
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
