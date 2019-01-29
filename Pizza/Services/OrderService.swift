//
//  OrderService.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

protocol OrderServicePostDelegate: class {
    func didSuccessfullyAddOrder(order: OrderGet, for restaurant: Restaurant)
    func didFailAddingOrder(error: Error)
}

protocol OrderServiceGetDelegate: class {
    func didLoad(order: OrderDetails)
    func didFail(error: Error)
}

class OrderService {

    // MARK - Public properties
    var orderIds: [Int] = []
    weak var postDelegate: OrderServicePostDelegate?
    weak var getDelegate: OrderServiceGetDelegate?

    // MARK - Initializers
    init(apiService: APIService) {
        self.apiService = apiService
    }

    // MARK - Public methods
    func push(order: OrderGet) {
        orderIds.append(order.id)
    }

    func loadOrder(for id: Int) {

        let url = Endpoint.order.url(with: id)
        apiService.get(from: url) { [weak self] (result: APIService.Result<OrderDetails>) in
            switch result {
            case .success(let order):
                self?.getDelegate?.didLoad(order: order)
            case .error(let error):
                self?.getDelegate?.didFail(error: error)
            }
        }
    }

    func sendOrder(with items: [CartItem], for restaurant: Restaurant) {

        let cartItems = items.map({ CartItems(id: $0.id, quantity: $0.quantity)})
        let orderPostData = OrderPost(cart: cartItems, restaurantId: restaurant.id)

        let url = Endpoint.orders.url
        apiService.post(from: url, parameters: orderPostData) { [weak self] (result: APIService.Result<OrderGet>) in
            switch result {
            case .success(let order):
                self?.postDelegate?.didSuccessfullyAddOrder(order: order, for: restaurant)
            case .error(let error):
                self?.postDelegate?.didFailAddingOrder(error: error)
            }
        }
    }

    // MARK - Private properties
    private var apiService: APIService
}
