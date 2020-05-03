//
//  FirebaseHelper.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseHelper {
    
    typealias urlBlock = ((_ url: URL?) -> ())
    
    static func getTotalUserCount(completion: @escaping (_ value: (Int,Int)) -> Void){
        
        var androidUser = 0
        var iOSUser = 0
        
        let androidPath = Database.database().reference(withPath: "Android-logs")
        
        let iosPath = Database.database().reference(withPath: "iOS").child("Prod-Logs").child("GeneralLogs")
        
        iosPath.observeSingleEvent(of: .value) { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                iOSUser = Array(postDict.keys).count
            }
            
            androidPath.observeSingleEvent(of: .value) { snapshot in
                if let postDict = snapshot.value as? [String : AnyObject] {
                    androidUser = Array(postDict.keys).count
                }
                
                completion((iOSUser, androidUser))
            }
        }
    }
    
    static func getBasePath(for type: String) -> DatabaseReference? {
        
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }
        
        if type == "bio" {
            return Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("bio")
        } else if type == "post" {
            return Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("post")
        } else if type == "diy" {
            return Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("diy")
        } else if type == "sell" {
            return Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("sell")
        } else if type == "studio" {
            return Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("studio")
        } else if type == "globalPost" {
            return Database.database().reference(withPath: "globalPost")
        } else {
            return nil
        }
    }
    
    static func setUserPost(for post: PostModel, completed: @escaping (_ success: Bool)-> Void) {
        
        guard let user = Auth.auth().currentUser else {
            completed(false)
            return
        }
        
        FirebaseHelper.uploadImageToPost(image: post.beforePhoto!) { (beforePhotoPathURL) in
            
            FirebaseHelper.uploadImageToPost(image: post.afterPhoto!) { (afterPhotoPathURL) in
                
                if let postPath = getBasePath(for: "post"), let time = TimeFormatter.getCurrentLocalTimeStamp() {
                    
                    let timePostPath = postPath.child(time)
                    
                    let dict = post.getDictionary(before: beforePhotoPathURL!.absoluteString,
                                                  after: afterPhotoPathURL!.absoluteString)
                    timePostPath.setValue(dict)
                    
                    if let globalPostPath = getBasePath(for: "globalPost") {
                        
                        let timePostPath = globalPostPath.child(time)
                        var dict = post.getDictionary(before: beforePhotoPathURL!.absoluteString,
                                                      after: afterPhotoPathURL!.absoluteString)
                        dict["email"] = user.email ?? ""
                        dict["name"] = user.displayName ?? ""
                        timePostPath.setValue(dict)
                    }
                    
                    completed(true)
                } else {
                    completed(false)
                }
            }
        }
    }
    
    static func setDataInBio(for key: String, value: String) {
        if let path = getBasePath(for: "bio") {
            let key = path.child(key)
            key.setValue(value)
        }
    }
    
    static func setDataInStudio(for title: String, image: UIImage, completed: @escaping (_ success: Bool)-> Void) {
        
        if let path = getBasePath(for: "studio") {
            
            FirebaseHelper.uploadImageToStudio(image: image) { (url) in
                if let url = url?.absoluteString {
                    let name = path.child(title)
                    name.setValue(url)
                    completed(true)
                } else {
                    completed(false)
                }
            }
        } else {
            completed(false)
        }
    }
    
    static func uploadImageToPost(image: UIImage, completionBlock: @escaping urlBlock) {
        
        guard let time = TimeFormatter.getCurrentLocalTimeStamp() else {
            completionBlock(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("post_images/\(time).png")
        
        if let uploadData = image.pngData(){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error == nil {
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            
                            completionBlock(nil)
                            return
                        }
                        print(downloadURL.absoluteString)
                        completionBlock(downloadURL)
                    }
                } else {
                    completionBlock(nil)
                }
            }
        }
    }
    
    static func uploadImageToStudio(image: UIImage, completionBlock: @escaping urlBlock) {
        
        guard let email = Auth.auth().currentUser?.email, let time = TimeFormatter.getCurrentLocalTimeStamp() else {
            completionBlock(nil)
            return
        }
        
        let imagePath = "studio/\(email.replacingOccurrences(of: ".", with: "_"))/\(time).png"
        
        let storageRef = Storage.storage().reference().child(imagePath)
        
        if let uploadData = image.pngData(){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error == nil {
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            
                            completionBlock(nil)
                            return
                        }
                        print(downloadURL.absoluteString)
                        completionBlock(downloadURL)
                    }
                } else {
                    completionBlock(nil)
                }
            }
        }
    }
}
