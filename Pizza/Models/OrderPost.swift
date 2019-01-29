//
//  OrderPost.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

struct OrderPost: Codable {
    var cart: [CartItems]
    var restaurantId: Int

    enum CodingKeys: String, CodingKey {
        case restaurantId = "restuarantId"
        case cart
    }
}
