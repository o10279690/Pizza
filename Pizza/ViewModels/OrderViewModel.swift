//
//  OrderViewModel.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

protocol OrderViewModelDelegate: class {
    func didLoadOrders()
}

class OrderViewModel {

    // MARK - Public properties
    private(set) var orders: [OrderDetails] = []
    weak var delegate: OrderViewModelDelegate?

    // MARK - Initializers
    init(with orderService: OrderService) {
        self.orderService = orderService
    }

    // MARK: - Public methods
    func loadOrders() {
        for orderId in orderService.orderIds {
            orderService.loadOrder(for: orderId)
            loadingState[orderId] = .loading
        }
    }

    // MARK - Private properties
    private var loadingState: [Int: LoadingStatus] = [:]
    private var orderService: OrderService

    private var allOrdersAreLoaded: Bool {
        return loadingState.allSatisfy { (key, value) -> Bool in
            return value == .loaded
        }
    }
}

// MARK: - OrderServiceGetDelegate methods
extension OrderViewModel: OrderServiceGetDelegate {
    func didLoad(order: OrderDetails) {
        loadingState[order.id] = .loaded
        orders.append(order)

        if allOrdersAreLoaded {
            delegate?.didLoadOrders()
        }
    }

    func didFail(error: Error) {
        // TODO: error handling
        print("Show an error message")
    }
}
