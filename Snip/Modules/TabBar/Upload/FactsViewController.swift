//
//  FactsViewController.swift
//  Snip
//
//  Created by Amitabha Saha on 03/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit

class FactsViewController: BaseViewController {
    
    let facts = ["150 billion items of clothing​ are produced globally every year.", "700 gallons of water ​are used to produce 1​ cotton shirt.", "That's equivalent to drinking ​8 cups of water​ per day for ​3.5 years.", "10% of the world’s emissions​ are produced by the fashion industry.", "It takes ​80 years for clothes to break down​ in the landfills.", "95% of discarded clothing​ can be recycled or upcycled.", "On average, people wear their clothing items ​7 times​ before throwing them away.", "On average, an individual​ spends $1,700​ on clothing per year.", "Textile waste is estimated to ​increase by 60%​ between 2015 and 2030."]
    
    @IBOutlet weak var factLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
        
        let rand = arc4random()%9
        let fact = "Did you Know: \n" + facts[Int(rand)]
        factLabel.text = fact
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        post()
    }
    
    func post() {
        
        guard let post = SharedData.instance.currentPost else { return }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.hidesBackButton = true
        
        FirebaseHelper.setUserPost(for: post) { (success) in
            
            if success {
                DispatchQueue.main.async {
                    self.tabBarController?.tabBar.isHidden = false
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.showError(message: "Failed to post your DIY")
                self.navigationItem.hidesBackButton = false
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
