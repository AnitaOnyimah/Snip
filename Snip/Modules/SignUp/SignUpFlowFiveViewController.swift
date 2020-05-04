//
//  SignUpFlowFiveViewController.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation
import UIKit

class SignUpFlowFiveViewController: BaseViewController {
    
    let facts = ["150 billion items of clothing​ are produced globally every year.", "700 gallons of water ​are used to produce 1​ cotton shirt.", "That's equivalent to drinking ​8 cups of water​ per day for ​3.5 years.", "10% of the world’s emissions​ are produced by the fashion industry.", "It takes ​80 years for clothes to break down​ in the landfills.", "95% of discarded clothing​ can be recycled or upcycled.", "On average, people wear their clothing items ​7 times​ before throwing them away.", "On average, an individual​ spends $1,700​ on clothing per year.", "Textile waste is estimated to ​increase by 60%​ between 2015 and 2030."]
    
    @IBOutlet weak var factLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let rand = arc4random()%9
        let fact = "Did you Know: \n" + facts[Int(rand)]
        factLabel.text = fact
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            if let tabBar: UITabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBarController") as? UITabBarController {
                UserDefaults.standard.set(true, forKey: "user_logged_in")
                self.navigationController?.pushViewController(tabBar, animated: true)
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
