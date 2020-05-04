//
//  ShowProfile.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit

class ShowProfile: UIView {

    @IBOutlet weak var gripperView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let images = [UIImage(named: "girl1.jpg"), UIImage(named: "girl2.jpeg"), UIImage(named: "girl3.jpeg"), UIImage(named: "girl4.jpg"), UIImage(named: "girl5.jpeg"), UIImage(named: "man1.jpg"), UIImage(named: "pants.jpg"),UIImage(named: "girl1.jpg"), UIImage(named: "girl2.jpeg"), UIImage(named: "girl3.jpeg"), UIImage(named: "girl4.jpg"), UIImage(named: "girl5.jpeg"), UIImage(named: "man1.jpg"), UIImage(named: "pants.jpg")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShowProfile" , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        setUpUI()
    }
    
    func setUpUI() {
        gripperView.layer.cornerRadius = 2
        gripperView.clipsToBounds = true
    }
    
    func reloadCollectionView() {
        
        configureCollectionView()
        collectionView.reloadData()
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
}

extension ShowProfile: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: DIYCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DIYCollectionViewCell", for: indexPath) as? DIYCollectionViewCell {
            cell.backgroundColor = .lightGray
            cell.itemIMageView.image = images[indexPath.row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
