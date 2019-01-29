//
//  RestaurantViewCell.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewCell: UITableViewCell {

    // MARK: - Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public methods
    func configure(with model: Restaurant, location: CLLocation) {
        self.nameLabel.text = model.name
        self.addressLabel.text = model.address1
        self.cityLabel.text = model.address2
        // Convert to km and only keep two decimals
        let distance = String(format: "%.2f", model.distance(to: location) / 1000)
        self.distanceLabel.text = "\(distance) km"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
}
