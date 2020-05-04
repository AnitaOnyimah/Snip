//
//  LoginViewController.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        guard let email = emailField.text, email.isValidEmail() else {
            self.showError(message: "Enter email address")
            return
        }
        
        guard let password = passwordField.text, password.count >= 6 else {
            self.showError(message: "Enter a password more than or equal to 6 character")
            return
        }
        
        
        self.showSpinner()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            
            self?.hideSpinner()
            
            if let error = error {
                Logger.log("Error: \(error.localizedDescription)")
                strongSelf.showError(message:error.localizedDescription)
            } else {
                Logger.log("Login Successful")
                SharedData.instance.user = user?.user
                strongSelf.navigationController?.setNavigationBarHidden(true, animated: true)
                
                if let tabBar: UITabBarController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBarController") as? UITabBarController {
                    UserDefaults.standard.set(true, forKey: "user_logged_in")
                    self?.navigationController?.pushViewController(tabBar, animated: true)
                    
                }
            }
        }
    }
}
