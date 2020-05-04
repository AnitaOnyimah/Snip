//
//  PreviewPostViewController.swift
//  Snip
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit
import Firebase

class PreviewPostViewController: BaseViewController {
    
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var hashTagsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gpLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        postView.layer.borderColor = UIColor.gray.cgColor
        postView.layer.borderWidth = 1
        
        nameLabel.text = Auth.auth().currentUser?.displayName
        location.text = SharedData.instance.currentPost?.location
        itemImageView.image = SharedData.instance.currentPost?.afterPhoto
        itemImageView.contentMode = .scaleAspectFill
        hashTagsLabel.text = (SharedData.instance.currentPost?.tags.joined(separator: " ") ?? "")
        descriptionLabel.text =  SharedData.instance.currentPost?.process
        
        self.gpLabel.text = "GP ..."
        FirebaseHelper.getBasePath(for: "post")?.observeSingleEvent(of: .value, with: { (snap) in
            if let values = snap.value as? [String:Any] {
                self.gpLabel.text = "GP \(Array(values.keys).count+1)"
            } else {
                self.gpLabel.text = "GP 1"
            }
        })
        
        userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
        userPhoto.layer.masksToBounds = true
        userPhoto.image = #imageLiteral(resourceName: "girl4")
        userPhoto.contentMode = .scaleAspectFill
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        guard let post = SharedData.instance.currentPost else { return }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.hidesBackButton = true
        
        self.showSpinner()
        
        FirebaseHelper.setUserPost(for: post) { (success) in
            self.hideSpinner()
            
            if success {
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showError(message: "Failed to post your DIY")
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.hidesBackButton = true
            }
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
