//
//  HomeTableViewCell.swift
//  Snip
//
//  Created by Anita Onyimah on 02/05/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ImageSlideshow

protocol HomeTableViewCellDelegate {
    func bookMarkTapped()
    func commentTapped()
    func sendMessageTapped(with message: String, for indexPath: IndexPath)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gpPoint: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var beforeAfterLabel: UILabel!
    @IBOutlet weak var lastCommentLabel: UILabel!
    
    var indexPath: IndexPath?
    var delegate: HomeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.init(named: "color2")
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        imageSlider.pageIndicator = pageIndicator
        imageSlider.delegate = self
        beforeAfterLabel.text = "After"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCell(with dataModel: [String: Any]) {
        
        if let namet = dataModel["name"] as? String {
            name.text = namet
        }
        
        if let comment = dataModel["lastComment"] as? String {
            lastCommentLabel.text = comment
        }
        
        if let locationt = dataModel["location"] as? String {
            location.text = locationt
        }
        
        if let process = dataModel["process"] as? String {
            descriptionLabel.text = process
        }
        
        self.gpPoint.text = "GP ..."
        if let email = dataModel["email"] as? String {
            
            Database.database().reference(withPath: "User").child(email.replacingOccurrences(of: ".", with: "_")).child("post").observeSingleEvent(of: .value, with: { (snap) in
                
                if let values = snap.value as? [String:Any] {
                    self.gpPoint.text = "GP \(Array(values.keys).count)"
                } else {
                    self.gpPoint.text = "GP 1"
                }
            })
        }
        
        if let beforePhoto = dataModel["beforePhoto"] as? String, let afterPhoto = dataModel["afterPhoto"] as? String {
            
            guard let beforeSource =  KingfisherSource(urlString: beforePhoto) else {
                return
            }
            
            guard let afterSource =  KingfisherSource(urlString: afterPhoto) else {
                return
            }
            
            imageSlider.setImageInputs([ afterSource,  beforeSource])
            imageSlider.setCurrentPage(0, animated: false)
        }
        
        if let tagsA = dataModel["tags"] as? [String] {
            tags.text = tagsA.joined(separator: " ")
        }
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func bookmarkIconTapped(_ sender: Any) {
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        guard let indexPath = indexPath else { return }
        
        self.delegate?.sendMessageTapped(with: commentTextField.text ?? "", for: indexPath)
        commentTextField.text = ""
    }
}


extension HomeTableViewCell: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if page == 0 {
            beforeAfterLabel.text = "After"
        } else {
            beforeAfterLabel.text = "Before"
        }
    }
}
