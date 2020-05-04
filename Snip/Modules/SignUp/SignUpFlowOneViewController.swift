//
//  SignUpFlowOneViewController.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit

class SignUpFlowOneViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inputAgeAction(_ sender: Any) {
        TextAlertView.showAlert(on: self, title: "Enter Your Age", placeHolder: "Type your age here") { (val) in
            if let val = val {
                FirebaseHelper.setDataInBio(for: "age", value: val)
            }
        }
    }
    
    @IBAction func inputGenderAction(_ sender: Any) {
        TextAlertView.showAlert(on: self, title: "Enter Your Gender", placeHolder: "Type your gender here") { (val) in
            
            if let val = val {
                FirebaseHelper.setDataInBio(for: "gender", value: val)
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
