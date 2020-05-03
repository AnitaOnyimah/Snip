//
//  LocationManager.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//
import Foundation
import CoreLocation
import MapKit

open class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    public let manager = CLLocationManager()
    private var _currentLocation: CLLocation?
    
    public var currentLocation: CLLocation? {
        get {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse {
                if let location = _currentLocation,
                    location.coordinate.latitude != 0.0 && location.coordinate.longitude != 0.0 {
                    return _currentLocation
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set (newValue) {
            _currentLocation = newValue
        }
    }
    
    public var lastUpdatedLocation: CLLocation?
    
    public var didReceiveCurrentLocation: ((_ location: CLLocation?) -> Void)? // Callback to get the currentLocation once access is granted
    
    public var locationAccessNotDetermined: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    private override init() {
        
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
    }
    
    public func requestPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            currentLocation = manager.location
            
            if let callBack = didReceiveCurrentLocation {
                callBack(currentLocation)
                didReceiveCurrentLocation = nil // To prevent it from getting called multiple times
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        currentLocation = location
        didReceiveCurrentLocation?(location)
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didReceiveCurrentLocation?(nil)
        manager.stopUpdatingLocation()
    }
}
