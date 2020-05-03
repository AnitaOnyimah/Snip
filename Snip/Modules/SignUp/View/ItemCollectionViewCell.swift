//
//  ItemCollectionViewCell.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageView.layer.cornerRadius = 59
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(named: "color1")?.cgColor
        
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(named: "color1")
        label.textColor = UIColor.white
    }

    func setImageAndName(image: UIImage?, name: String) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        label.text = name
    }
}
