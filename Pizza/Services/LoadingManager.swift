//
//  LoadingManager.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation
import CoreLocation

enum LoadingStatus {
    case loading, loaded, error
}

protocol LoadingManagerDelegate: class {
    func dataLoaded(with location: CLLocation, and restaurants: [Restaurant])
    func locationDenied()
}

class LoadingManager {
    // MARK - Public properties
    weak var delegate: LoadingManagerDelegate?

    // MARK - Public methods
    func load() {
        loadingStatus = .loading
    }

    // MARK - Public properties
    private var location: CLLocation? {
        didSet {
            dataLoaded()
        }
    }

    private var restaurants: [Restaurant]? {
        didSet {
            dataLoaded()
        }
    }
    private var loadingStatus: LoadingStatus?

    // MARK - Private methods
    private func dataLoaded() {
        guard let location = location, let restaurants = restaurants, loadingStatus == .loading else {
            return
        }
        loadingStatus = .loaded


        delegate?.dataLoaded(with: location, and: restaurants)
    }
}

// MARK - RestaurantServiceDelegate methods
extension LoadingManager: RestaurantServiceDelegate {
    func didFetch(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }

    func didFail(error: Error) {
        // TODO: show an error message and maybe a retry button
        print("Error getting restaurants")
    }
}

// MARK - LocationServiceDelegate methods
extension LoadingManager: LocationServiceDelegate {
    func requestDenied() {
        self.delegate?.locationDenied()
    }

    func didGetLocation(location: CLLocation) {
        self.location = location
    }
}
