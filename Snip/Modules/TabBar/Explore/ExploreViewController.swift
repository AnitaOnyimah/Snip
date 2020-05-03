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
