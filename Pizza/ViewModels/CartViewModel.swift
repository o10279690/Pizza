//
//  CartViewModel.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

// Structure to retain information for the ui
struct CartItem {
    var id: Int
    var item: MenuItem
    var quantity: Int
}

class CartViewModel {

    // MARK - Public properties
    private(set) var cartItems: [CartItem] = []
    private(set) var restaurant: Restaurant

    var amount: CGFloat {
        let value = cartItems
            .map { (price: $0.item.price, quantity: $0.quantity)}
            .reduce(into: 0) { (result, next) in
                result += next.price * next.quantity
            }
        return CGFloat(value)
    }

    // MARK - Initializers
    init(with items: [MenuItem], restaurant: Restaurant) {
        self.items = items
        self.restaurant = restaurant

        let dict = Dictionary(grouping: items, by: { $0.id })
        for (key, value) in dict where value.first != nil {
            cartItems.append(CartItem(id: key, item: value.first!, quantity: value.count))
        }
    }

    // MARK: - Public methods
    func changeQuantity(of item: CartItem, to quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = quantity
        }
    }

    // MARK - Private properties
    private var items: [MenuItem]
    
}
