//
//  MenuItem.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    var id: Int
    var category: String
    var name: String
    var price: Int
    var rank: Int?
    var topping: [String]?
}
