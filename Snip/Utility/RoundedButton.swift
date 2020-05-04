//
//  RoundedButton.swift
//  Snap
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anita. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable public var roundedRect: Bool = false {
        didSet {
            if self.roundedRect {
                self.layer.cornerRadius = self.frame.size.height/2
            }
        }
    }
    
    
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderWidth = 2
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
}
