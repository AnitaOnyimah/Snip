//
//  AfterPhotoViewController.swift
//  Snip
//
//  Created by Amitabha Saha on 02/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices

class AfterPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post = SharedData.instance.currentPost
    
    var dataSource: PHFetchResult<PHAsset>? {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                if let dataSource = self.dataSource {
                    
                    let picker = GalleryImagePicker()
                    picker.getImage(for: dataSource.object(at: 0)) { (image) in
                        self.imageView.image = image
                        self.post?.afterPhoto = image
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let picker = GalleryImagePicker()
        picker.load(on: self)
        self.dataSource = picker.fetchResult
    }
    
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DIYCollectionViewCell.self, forCellWithReuseIdentifier: "DIYCollectionViewCell")
        collectionView.register(UINib(nibName: "DIYCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DIYCollectionViewCell")
        
        let width = (UIScreen.main.bounds.size.width-7)/3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    @objc func cancelAction() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.selectedIndex = 0
    }
}


extension AfterPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: DIYCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DIYCollectionViewCell", for: indexPath) as? DIYCollectionViewCell {
            
            if let dataSource = dataSource {
                
                let picker = GalleryImagePicker()
                picker.getImage(for: dataSource.object(at: indexPath.row)) { (image) in
                    cell.itemIMageView.image = image
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let dataSource = dataSource {
            
            let picker = GalleryImagePicker()
            picker.getImage(for: dataSource.object(at: indexPath.row)) { (image) in
                self.imageView.image = image
                self.post?.afterPhoto = image
            }
        }
    }
}
