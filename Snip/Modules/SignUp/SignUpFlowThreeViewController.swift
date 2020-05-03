//
//  SignUpFlowThreeViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit

class SignUpFlowThreeViewController: BaseViewController {
    
    let dataSource = [("Signup 1.4_Jeans.jpg","Jeans"), ("Signup 1.4_Shorts.jpg","Shorts"), ("Signup 1.4_Tops:Shirts.jpg", "Top/Shirts"), ("Signup 1.4_Dresses.jpg", "Dresses"), ("Signup 1.4_Skirts.jpg", "Skirts"), ("Signup 1.4_Accessories.jpg", "Accessories")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        flowLayout.minimumLineSpacing = 10
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

extension SignUpFlowThreeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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
        FirebaseHelper.setDataInBio(for: "DIY Item", value: dataSource[indexPath.row].1)
        self.performSegue(withIdentifier: "showNextSegue2", sender: nil)
    }
}
