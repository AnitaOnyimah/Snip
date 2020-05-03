//
//  SignUpFlowTwoViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit

class SignUpFlowTwoViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataSource = [("Signup 1.3_Tie Dye.jpg","Tie Dye"), ("Signup 1.3_Embroidery.jpg","Embroidary"), ("Signup 1.3_Beddazling.jpg", "Beddazling"), ("Signup 1.3_Sewing.jpg", "Sewing"), ("Signup 1.3_Knitting.jpg", "Knitting"), ("Signup 1.3_Painting.jpg", "Painting")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureCollectionView()
    }
    
    func configureCollectionView() {
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 127.0, height: 174.0)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.minimumLineSpacing = 20
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SignUpFlowTwoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            cell.setImageAndName(image: UIImage(named: dataSource[indexPath.row].0), name: dataSource[indexPath.row].1)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FirebaseHelper.setDataInBio(for: "DIY Category", value: dataSource[indexPath.row].1)
    }
}
