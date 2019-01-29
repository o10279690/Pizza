//
//  LocationService.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func requestDenied()
    func didGetLocation(location: CLLocation)
}

class LocationService: NSObject {

    // MARK - Public properties
    var locationManager: CLLocationManager!
    weak var delegate: LocationServiceDelegate?

    // MARK - Initializers
    override init() {
        super.init()

        locationManager = CLLocationManager()
        locationManager.delegate = self
    }

    // MARK - Public methods
    func requestLocation() {
        locationManager.startUpdatingLocation()

        if CLLocationManager.locationServicesEnabled() {
            let status  = CLLocationManager.authorizationStatus()

            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }

            if status == .denied {
                delegate?.requestDenied()
            }
        } else {
            // TODO: maybe handle differently if the services are disabled
            delegate?.requestDenied()
        }
    }
}

// MARK - CLLocationManagerDelegate methods
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.last else {
            return
        }
        delegate?.didGetLocation(location: currentLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: maybe handle differently based on the error
        print("Error getting location")
    }
}
