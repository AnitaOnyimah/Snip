//
//  TextAlertView.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation
import UIKit

class TextAlertView {
    
    static func showAlert(on view: UIViewController, title: String, placeHolder: String? = nil, completion: @escaping (_ input: String?) -> Void) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Enter", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            if let textFields = alert.textFields, let text = textFields[0].text, !text.isEmpty {
                 completion(text)
            } else {
                completion(nil)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            completion(nil)
        })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = placeHolder ?? "Type here"
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        view.present(alert, animated: true, completion: nil)
    }
    
}
