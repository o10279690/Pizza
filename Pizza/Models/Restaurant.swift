//
//  Restaurant.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant: Codable {
    var id: Int
    var name: String
    var address1: String
    var address2: String
    var latitude: Double
    var longitude: Double
}

extension Restaurant {
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    func distance(to location: CLLocation) -> CLLocationDistance {
        return self.location.distance(from: location)
    }
}
