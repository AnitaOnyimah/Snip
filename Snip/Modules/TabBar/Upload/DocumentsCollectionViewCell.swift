//
//  DocumentsCollectionViewCell.swift
//  DocumentScanner
//
//  Created by ASTech on 25/03/19.
//  Copyright © 2019 ASTech. All rights reserved.
//

import UIKit

class DocumentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImage(image: UIImage, mode: ContentMode) {
        
        self.imageView.contentMode = mode
        self.imageView.image = image
        
    }
    
    func loadImage(path: String) {
        
        if FileManager.default.fileExists(atPath: path) {
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }

}
