//
//  MenuLoader.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

protocol MenuLoaderDelegate: class {
    func didLoad(menu: [MenuItem], for restaurant: Restaurant)
    func didFail(error: Error)
}

class MenuLoader {

    // MARK - Public properties
    weak var delegate: MenuLoaderDelegate?

    // MARK - Initializers
    init(apiService: APIService) {
        self.apiService = apiService
    }

    // MARK - Public methods
    func loadMenu(for restaurant: Restaurant) {
        let url = Endpoint.restaurantsMenu.url(with: restaurant.id)
        apiService.get(from: url) { [weak self] (result: APIService.Result<[MenuItem]>) in
            switch result {
            case .success(let menuItems):
                self?.delegate?.didLoad(menu: menuItems, for: restaurant)
            case .error(let error):
                self?.delegate?.didFail(error: error)
            }
        }
    }

    // MARK - Private properties
    private var apiService: APIService
}
