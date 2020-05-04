//
//  BaseViewController.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    struct Constants {
        static let okString = SnapStrings.ok
        static let cancelString = SnapStrings.cancel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    func showSpinner(_ message: String = "") {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = message
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func navigateToLogin() {
        
    }
    
    func showError(title: String? = nil, message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: Constants.okString, style: .default, handler: { _ in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    /**
     Method to add an alert with a given title and message for "OK", "Cancel" actions
     */
    func showAlert(with title: String?, message: String?, showCancel : Bool = false, handleOk: @escaping (() -> Void) = {}, handleCancel: @escaping (() -> Void) = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //update the alert button color
        //alertController.view.tintColor = Common.alertTintColor

        //create actions
        let okAction = UIAlertAction(title: Constants.okString, style: .default) { (_) in
            handleOk()
        }
        if showCancel {
            let cancelAction = UIAlertAction(title: Constants.cancelString, style: .cancel) { (_) in
                handleCancel()
            }
            alertController.addAction(cancelAction)
        }

        //Add actions
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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

