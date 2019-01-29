//
//  CartItems.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

struct CartItems: Codable {
    var id: Int
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case id = "menuItemId"
        case quantity
    }
}
