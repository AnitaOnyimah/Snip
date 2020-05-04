//
//  GalleryImagePicker.swift
//  Snip
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation
import Photos
import PhotosUI
import MobileCoreServices

class GalleryImagePicker {
    
    var fetchResult: PHFetchResult<PHAsset>?
    let imageManager = PHCachingImageManager()
    
    var images: ((_ fetchResult: PHFetchResult<PHAsset>?)->Void)?
    
    var dataSource: [UIImage]?
    
    func load(on parent: UIViewController) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == PHAuthorizationStatus.authorized {
            self.fetchPhotosFromLibrary()
        } else if status == PHAuthorizationStatus.denied {
            self.requestAccessToPhotos(parent: parent)
        } else if status == PHAuthorizationStatus.notDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if newStatus == PHAuthorizationStatus.authorized {
                    self.fetchPhotosFromLibrary()
                } else {
                    self.requestAccessToPhotos(parent: parent)
                }
                
            })
        } else if status == PHAuthorizationStatus.restricted {
            self.requestAccessToPhotos(parent: parent)
        }
    }
    
    func requestAccessToPhotos(parent: UIViewController) {
        
        let alertController = UIAlertController (title: "Access Denied", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    
                    UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                        
                    })
                }
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            parent.present(alertController, animated: true, completion: nil)
        }
        
        self.images?(nil)
    }
    
    
    func fetchPhotosFromLibrary() {
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        self.images?(self.fetchResult)
    }
    
    func getImage(for asset: PHAsset, completion: @escaping ((_ image: UIImage?) -> ())) {
        
        let thumbnailSize = CGSize(width: 400.0, height: 400.0)
        
        let options = PHImageRequestOptions()
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: options) { (image, info) in
            completion(image)
        }
    }
}
