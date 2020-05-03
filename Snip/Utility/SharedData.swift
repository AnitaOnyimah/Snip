//
//  SharedData.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import Firebase

class PostModel {
    
    var beforePhoto: UIImage?
    var afterPhoto: UIImage?
    var location: String?
    var toolsUsed: String?
    var process: String?
    var extimatedTime: String?
    var difficultyLevel: Int = 1
    var tags: [String] = [String]()
    var popularInUserArea: [String] = [String]()
    var price: String = "$5.0"
    var forSale: Bool = true
    
    func getDictionary(before: String, after: String) -> [String: Any] {
        let m: [String: Any] = ["beforePhoto": before,
                 "afterPhoto": after,
                 "location": location ?? "-",
                 "toolsUsed": toolsUsed ?? "-",
                 "process": process ?? "-",
                 "extimatedTime": extimatedTime ?? "",
                 "difficultyLevel": difficultyLevel,
                 "tags": tags,
                 "lastComment": "",
                 "popularInUserArea": popularInUserArea,
                 "price": price,
                 "forSale": forSale]
        
        return m
    }
}

class SharedData {
    
    static let instance = SharedData()
    var user: User?
    
    var currentPost: PostModel?
    
}
