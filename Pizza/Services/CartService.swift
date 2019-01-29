//
//  CartService.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

class CartService {

    // MARK - Public properties
    var cart: [Int: [MenuItem]] = [:]

    // MARK - Public methods
    func add(item: MenuItem, for restaurant: Int) {
        if cart[restaurant] == nil {
            cart[restaurant] = []
        }
        cart[restaurant]?.append(item)
    }

    func remove(item: MenuItem, for restaurant: Int) {
        if let index = cart[restaurant]?.firstIndex(where: { $0.id == item.id }) {
            cart[restaurant]?.remove(at: index)
        }
    }

    func clearCart(for restaurant: Int) {
        if cart[restaurant] != nil {
            cart[restaurant] = nil
        }
    }

    func changeQuantity(of itemId: Int, to quantity: Int, for restaurant: Int) {
        let data = cart[restaurant]?.filter{ $0.id == itemId }

        guard let item = data, item.count > 0 else {
            return
        }

        let diff = quantity - item.count

        if diff < 0 {
            for _ in 0..<abs(diff) {
                remove(item: item.first!, for: restaurant)
            }
        } else if diff > 0 {
            for _ in 0..<diff {
                add(item: item.first!, for: restaurant)
            }
        }
    }
}
