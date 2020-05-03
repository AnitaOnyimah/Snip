//
//  ExploreViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit
import MapKit
import DrawerView
import Firebase
import FirebaseFirestore

class ExploreViewController: BaseViewController {
    
    var drawerView: DrawerView!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(self, action: #selector(self.searchBarTextClearButtonClicked), for: .touchUpInside)
        }
    }
    
    func setUpDrawerView() {
        
        if drawerView != nil {
            return
        }
        
        drawerView = DrawerView()
        drawerView.delegate = self
        drawerView.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        drawerView.topMargin = 10
        drawerView.overlayVisibilityBehavior = .disabled
        drawerView.partiallyOpenHeight = 300
        drawerView.topMargin = 140
        drawerView.attachTo(view: self.view)
        
        // Set up the drawer here
        drawerView.snapPositions = [.open]
        drawerView.setPosition(.open, animated: false)
        
        setDarwerOpenState(to: drawerView)
    }
    
    func setDarwerCollapsedState(to drawer: DrawerView) {
        
        let results = ShowResults()
        results.tag = 101
        results.translatesAutoresizingMaskIntoConstraints = false
        drawer.addSubview(results)
        results.autoPinEdgesToSuperview(margin: 0)
        
    }
    
    func setDarwerOpenState(to drawer: DrawerView) {
        
        let results = ShowProfile()
        results.tag = 102
        results.translatesAutoresizingMaskIntoConstraints = false
        drawer.addSubview(results)
        results.autoPinEdgesToSuperview(margin: 0)
        
        results.reloadCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpDrawerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        if LocationManager.shared.locationAccessNotDetermined {
            LocationManager.shared.didReceiveCurrentLocation = {(location) in
                if let location = location {
                    self.reloadMapView(coordinate: location.coordinate)
                }
            }
        } else {
            if let location = LocationManager.shared.currentLocation {
                self.reloadMapView(coordinate: location.coordinate)
            }
            
            LocationManager.shared.didReceiveCurrentLocation = {(location) in
                if let location = location {
                    self.reloadMapView(coordinate: location.coordinate)
                }
            }
        }
    }
    
    func reloadMapView(coordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.4, longitudeDelta: 0.4)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cameraAction(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ExploreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //vision_images
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let time = TimeFormatter.getCurrentLocalTimeStamp() else {
            return
        }
        
        self.showSpinner()
        let imageName = time + ".png"
        let storageRef = Storage.storage().reference().child("vision_images/\(imageName)")
        
        storageRef.putData(image.pngData()!, metadata: nil) { (metadata, error) in
            print("Image Uploaded")
            if error == nil {
                Firestore.firestore().collection("images").document(imageName)
                    .addSnapshotListener { documentSnapshot, error in
                        self.hideSpinner()
                        if let error = error {
                            print("error occurred\(error)")
                            self.showError(message: error.localizedDescription)
                        } else {
                            if (documentSnapshot?.exists)! {
                                self.parseVisionResponse(data: documentSnapshot?.data())
                            } else {
                                print("waiting for Vision API data...")
                                self.showError(message: "Parsing Error")
                            }
                        }
                }
            } else {
                
                self.showError(message: error!.localizedDescription)
                self.hideSpinner()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func parseVisionResponse(data: [String: Any]?) {
        guard let data = data else { return }
        print(data)
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searched")
        self.view.endEditing(true)
        
        drawerView.snapPositions = [.partiallyOpen]
        drawerView.setPosition(.partiallyOpen, animated: true)
        
        setDarwerCollapsedState(to: drawerView)
    }
    
    @objc func searchBarTextClearButtonClicked() {
        print("Cancelled")
        self.view.endEditing(true)
        
        drawerView.snapPositions = [.open]
        drawerView.setPosition(.open, animated: true)
        
        setDarwerOpenState(to: drawerView)
    }
}


extension ExploreViewController: DrawerViewDelegate {
    
    func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
        
        if targetPosition == .open {
            
            removeAddedView(to: drawerView, tag: 101)
            setDarwerOpenState(to: drawerView)
            
        } else if targetPosition == .partiallyOpen {
            
            removeAddedView(to: drawerView, tag: 102)
            setDarwerCollapsedState(to: drawerView)
        }
    }
    
    func removeAddedView(to drawer: DrawerView, tag: Int) {
        drawerView.subviews.forEach { (view) in
            if view.tag == tag {
                view.removeFromSuperview()
            }
        }
    }
}


extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
