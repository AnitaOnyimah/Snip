//
//  SignUpFlowFourViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit

class SignUpFlowFourViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func beginnerAction(_ sender: Any) {
        FirebaseHelper.setDataInBio(for: "experience", value: "beginner")
    }
    
    
    @IBAction func intermediateAction(_ sender: Any) {
        FirebaseHelper.setDataInBio(for: "experience", value: "intermediate")
    }
    
    @IBAction func expertAction(_ sender: Any) {
        FirebaseHelper.setDataInBio(for: "experience", value: "expert")
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
