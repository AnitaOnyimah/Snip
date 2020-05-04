//
//  ViewController.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signUpAction(_ sender: Any) {
        
        guard let fname = fname.text, !fname.isEmpty else {
            self.showError(message: "Enter first name")
            return
        }
        
        guard let lname = lname.text, !lname.isEmpty else {
            self.showError(message: "Enter last name")
            return
        }
        
        guard let email = email.text, email.isValidEmail() else {
            self.showError(message: "Enter email address")
            return
        }
        
        guard let password = password.text, password.count >= 6 else {
            self.showError(message: "Enter a password more than or equal to 6 character")
            return
        }
        
        self.showSpinner()
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self?.hideSpinner()
                self?.showError(message: error.localizedDescription)
                
            } else {
                
                Auth.auth().signIn(withEmail: strongSelf.email.text!, password:strongSelf.password.text!) { [weak self] user, error in
                    
                    guard let strongSelf = self else { return }
                    
                    if let error = error {
                        strongSelf.hideSpinner()
                        strongSelf.showError(message: error.localizedDescription)
                    } else {
                        
                        if let userun = Auth.auth().currentUser {
                            
                            let changeRequest = userun.createProfileChangeRequest()
                            changeRequest.displayName = fname + " " + lname
                            changeRequest.commitChanges { (error) in
                                strongSelf.hideSpinner()
                                
                                FirebaseHelper.setDataInBio(for: "firstName", value: fname)
                                FirebaseHelper.setDataInBio(for: "lastName", value: lname)
                                
                                self?.performSegue(withIdentifier: "showSignUpFlow", sender: nil)
                            }
                        } else {
                           strongSelf.hideSpinner()
                        }
                    }
                }
            }
        }
    }
}

