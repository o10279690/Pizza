//
//  OrderDetailsViewCell.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

class OrderDetailsViewCell: UITableViewCell {

    // MARK: - Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public methods
    func configure(model: OrderDetails) {
        // TODO: update to show actual values and not ids
        orderLabel.text = "OrderId: \(model.id)"
        priceLabel.text = "\(model.totalPrice) SEK"
        restaurantLabel.text = "Restaurant: \(model.restaurantId)"
        deliveryTimeLabel.text = "Est. delivery: \(model.estimatedDelivery)"

        let productText = model.cart.map{ "Product: \($0.id) - Qt: \($0.quantity)"}.joined(separator: "\n")
        productsLabel.text = productText
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var restaurantLabel: UILabel!
    @IBOutlet private weak var deliveryTimeLabel: UILabel!
    @IBOutlet private weak var productsLabel: UILabel!
}
