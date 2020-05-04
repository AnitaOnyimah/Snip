//
//  InfoDIYViewController.swift
//  Snip
//
//  Created by Anita Onyimah on 04/19/20.
//  Copyright © 2020 Anitaa. All rights reserved.
//

import UIKit
import CoreLocation

class InfoDIYViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var toolsUsed: UITextField!
    @IBOutlet weak var processTextView: UITextView!
    @IBOutlet weak var timeTaken: UITextField!
    
    var post = SharedData.instance.currentPost
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationLabel.placeholder = "Fetching Location...."
        
        if LocationManager.shared.locationAccessNotDetermined {
            LocationManager.shared.didReceiveCurrentLocation = {(location) in
                if let location = location {
                    self.getAddress(for: location) { (address) in
                        self.locationLabel.text = address
                        self.post?.location = address
                    }
                }
            }
        } else {
            if let location = LocationManager.shared.currentLocation {
                getAddress(for: location) { (address) in
                    self.locationLabel.text = address
                    self.post?.location = address
                }
            }
            
            LocationManager.shared.didReceiveCurrentLocation = {(location) in
                if let location = location {
                    self.getAddress(for: location) { (address) in
                        self.locationLabel.text = address
                        self.post?.location = address
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        post?.location = locationLabel.text
        post?.extimatedTime = timeTaken.text
        post?.process = processTextView.text
        post?.toolsUsed = toolsUsed.text
    }

    func getAddress(for location: CLLocation, completion: @escaping (_ address: String) -> Void ) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks, let placemark = placemarks.first {
            
                completion("\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")")
            } else {
                completion("-,-")
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
    
    @IBAction func difficultyAction(_ sender: Any) {
        
        if let buttonTag = (sender as? UIButton)?.tag {
            self.post?.difficultyLevel = buttonTag-199
        }
    }
}
