//
//  LineWidthViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit

class LineWidthViewController: UIViewController {
    
    var valueChanged: ((_ value: CGFloat)->())!
    
    func setValue(_ value: CGFloat){
        
        let minButton: UIButton = self.view.viewWithTag(1) as! UIButton
        let midButton: UIButton = self.view.viewWithTag(2) as! UIButton
        let maxButton: UIButton = self.view.viewWithTag(3) as! UIButton
        
        switch value {
        case 3.0:
            minButton.setImage(UIImage(named:"small_circle_selected" ), for: .normal)
            midButton.setImage(UIImage(named:"medium_circle" ), for: .normal)
            maxButton.setImage(UIImage(named:"big_circle" ), for: .normal)
            break
        case 6.0:
            minButton.setImage(UIImage(named:"small_circle" ), for: .normal)
            midButton.setImage(UIImage(named:"medium_circle_selected" ), for: .normal)
            maxButton.setImage(UIImage(named:"big_circle" ), for: .normal)
            break
        case 9.0:
            minButton.setImage(UIImage(named:"small_circle" ), for: .normal)
            midButton.setImage(UIImage(named:"medium_circle" ), for: .normal)
            maxButton.setImage(UIImage(named:"big_circle_selected" ), for: .normal)
            break
        default: break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func maxLineWidthButtonAction(_ sender: Any) {
        
        if let valueChanged = valueChanged{
            valueChanged(9.0)
            setValue(9.0)
            self.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    
    
    @IBAction func midLineWidthAction(_ sender: Any) {
        
        if let valueChanged = valueChanged{
            valueChanged(6.0)
            setValue(6.0)
            self.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    
    @IBAction func minLineWidthAction(_ sender: Any) {
        
        if let valueChanged = valueChanged{
            valueChanged(3.0)
            setValue(3.0)
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
