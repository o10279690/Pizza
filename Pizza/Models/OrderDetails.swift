//
//  OrderDetails.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

struct OrderDetails: Codable {
    var id: Int
    var totalPrice: Int
    var orderedAt: String
    var estimatedDelivery: String
    var status: String
    var cart: [CartItems]
    var restaurantId: Int

    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case totalPrice
        case orderedAt
        case estimatedDelivery = "esitmatedDelivery"
        case status
        case restaurantId = "restuarantId"
        case cart
    }
}
