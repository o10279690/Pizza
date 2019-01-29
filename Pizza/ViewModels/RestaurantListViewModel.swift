//
//  RestaurantListViewModel.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation
import CoreLocation

class RestaurantListViewModel {

    // MARK - Public properties
    var items: [Restaurant]
    var location: CLLocation

    // MARK - Initializers
    init(with location: CLLocation, and restaurants: [Restaurant]) {
        items = restaurants.sorted(by: {$0.distance(to: location) < $1.distance(to: location) })
        self.location = location
    }
}
