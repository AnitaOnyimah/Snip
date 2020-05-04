//
//  TagDIYViewController.swift
//  Snip
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit
import Hashtags

class TagDIYViewController: UIViewController {
    
    @IBOutlet weak var tagView: HashtagView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var popularHashTags: HashtagView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var yesButton: RoundedButton!
    @IBOutlet weak var noButton: RoundedButton!
    
    var popularTags: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let jeansTag = HashTag(word: "#Jeans", withHashSymbol: false, isRemovable: false)
        let blingTag = HashTag(word: "#Bling", withHashSymbol: false, isRemovable: false)
        let topsTag = HashTag(word: "#Tops", withHashSymbol: false, isRemovable: false)
        
        popularHashTags.addTags(tags: [jeansTag, blingTag, topsTag])
        
        
        tagView.delegate = self
        popularHashTags.delegate = self
    }
    
    @IBAction func addTag(_ sender: Any) {
        
        if let text = tagTextField.text, !text.isEmpty {
            let tag = HashTag(word: text, withHashSymbol: true, isRemovable: false)
            tagView.addTag(tag: tag)
            tagTextField.text = ""
        }
    }
    
    @IBAction func yesAction(_ sender: Any) {
        
        priceLabel.isHidden = false
        priceTextField.isHidden = false
        
        noButton.backgroundColor = .white
        noButton.setTitleColor(UIColor(named: "color1"), for: .normal)
        
        yesButton.backgroundColor = UIColor(named: "color1")
        yesButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func noAction(_ sender: Any) {
        
        priceLabel.isHidden = true
        priceTextField.isHidden = true
        
        yesButton.backgroundColor = .white
        yesButton.setTitleColor(UIColor(named: "color1"), for: .normal)
        
        noButton.backgroundColor = UIColor(named: "color1")
        noButton.setTitleColor(.white, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        var post = SharedData.instance.currentPost
        
        post?.tags = tagView.hashtags.map{ $0.text }
        post?.popularInUserArea = popularTags
        post?.forSale = !priceTextField.isHidden
        if !priceTextField.isHidden, let text = priceTextField.text, !text.isEmpty {
            post?.price = text
        }
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

extension TagDIYViewController: HashtagViewDelegate {
    
    func taggedTapped(hashtag: HashTag, in view: HashtagView) -> UIColor? {
        
        if view == popularHashTags {
            
            if !popularTags.contains(hashtag.text) {
                popularTags.append(hashtag.text)
            }
            
            return UIColor(named: "color1")
        } else {
            return nil
        }
    }
    
    
    func hashtagRemoved(hashtag: HashTag) {
        
    }
    
    func viewShouldResizeTo(size: CGSize) {
        print(size)
    }
}
