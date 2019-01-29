//
//  RestaurantService.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

protocol RestaurantServiceDelegate: class {
    func didFetch(restaurants: [Restaurant])
    func didFail(error: Error)
}

class RestaurantService {

    // MARK - Public properties
    weak var delegate: RestaurantServiceDelegate?

    // MARK - Initializers
    init(apiService: APIService) {
        self.apiService = apiService
    }

    // MARK - Public methods
    func fetchStores() {
        let url = Endpoint.restaurants.url
        apiService.get(from: url) { [weak self] (result: APIService.Result<[Restaurant]>) in
            switch result {
            case .success(let restaurants):
                self?.delegate?.didFetch(restaurants: restaurants)
            case .error(let error):
                self?.delegate?.didFail(error: error)
            }
        }
    }

    // MARK - Private properties
    private var apiService: APIService
}
