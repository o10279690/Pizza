//
//  MenuViewModel.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate: class {
    func didLoadMenu()
}

class MenuViewModel {

    // MARK: Structs & Enums
    struct MenuObject {
        var category : String
        var items : [MenuItem]
    }

    // MARK - Public properties
    weak var delegate: MenuViewModelDelegate?

    private(set) var items: [MenuObject] = []
    private(set) var restaurant: Restaurant

    // MARK - Initializers
    init(with menuLoader: MenuLoader, restaurant: Restaurant) {
        self.menuLoader = menuLoader
        self.restaurant = restaurant
    }

    // MARK - Public methods

    func loadMenu() {
        menuLoader.loadMenu(for: restaurant)
    }

    // MARK - Private properties
    private var menuLoader: MenuLoader
}

// MARK: - MenuLoaderDelegate methods
extension MenuViewModel: MenuLoaderDelegate {
    func didLoad(menu: [MenuItem], for restaurant: Restaurant) {
        let dict = Dictionary(grouping: menu, by: { $0.category })

        for (key, value) in dict {
            items.append(MenuObject(category: key, items: value))
        }

        delegate?.didLoadMenu()
    }

    func didFail(error: Error) {
        // TODO: error handling
        print("Show an error message")
    }
}
