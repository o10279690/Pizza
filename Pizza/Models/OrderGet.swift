//
//  OrderGet.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

struct OrderGet: Codable {
    var id: Int
    var totalPrice: Int
    var orderedAt: String
    var estimatedDelivery: String
    var status: String

    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case totalPrice
        case orderedAt
        case estimatedDelivery = "esitmatedDelivery"
        case status
    }
}

