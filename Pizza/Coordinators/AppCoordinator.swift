
//
//  AppCoordinator.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator {

    // MARK - Initializers
    init(with window: UIWindow?) {
        self.window = window
    }

    // MARK - Public methods
    func start() {
        guard let window = window else {
            return
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        showLoadingFlow()
    }

    // MARK - Private properties
    private let window: UIWindow?

    private lazy var rootViewController: UINavigationController = {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }()

    private lazy var locationService: LocationService = {
        var locationService = LocationService()
        locationService.delegate = loadingManager
        return locationService
    }()

    private lazy var restaurantService: RestaurantService = {
        var restaurantService = RestaurantService(apiService: apiService)
        restaurantService.delegate = loadingManager
        return restaurantService
    }()

    private lazy var apiService = APIService()
    private lazy var cartService = CartService()

    private lazy var orderService: OrderService = {
        let orderService = OrderService(apiService: apiService)
        orderService.postDelegate = self
        return orderService
    }()

    private lazy var loadingManager: LoadingManager = {
        let loadingManager = LoadingManager()
        loadingManager.delegate = self
        return loadingManager
    }()

    private var location: CLLocation?
    private var restaurants: [Restaurant]?
    private var cartBarItem: UIBarButtonItem?
    private var ordersBarItem: UIBarButtonItem?

    // MARK - Private methods
    private func showLoadingFlow() {
        let loadingVC = LoadingViewController()
        rootViewController.pushViewController(loadingVC, animated: false)

        locationService.requestLocation()
        restaurantService.fetchStores()
        loadingManager.load()
    }

    private func showRestaurants(with location: CLLocation, and restaurants: [Restaurant]) {
        let viewModel = RestaurantListViewModel(with: location, and: restaurants)

        let restaurantsVC = RestaurantListTableViewController()
        restaurantsVC.viewModel = viewModel
        restaurantsVC.delegate = self

        ordersBarItem = UIBarButtonItem(title: "Orders", style: .plain, target: self, action: #selector(showOrders))
        restaurantsVC.navigationItem.rightBarButtonItem = ordersBarItem

        rootViewController.setNavigationBarHidden(false, animated: false)
        rootViewController.setViewControllers([restaurantsVC], animated: true)
    }

    private func showMenu(restaurant: Restaurant) {
        rootViewController.setNavigationBarHidden(false, animated: false)

        let menuLoader = MenuLoader(apiService: apiService)
        let viewModel = MenuViewModel(with: menuLoader, restaurant: restaurant)
        let menuVC = MenuViewController()
        menuLoader.delegate = viewModel
        viewModel.delegate = menuVC
        menuVC.viewModel = viewModel
        menuVC.delegate = self

        var title = "Cart"
        if let count = cartService.cart[restaurant.id]?.count {
            title = "Cart (\(count))"
        }
        cartBarItem = UIBarButtonItem(title: title, style: .plain, target: menuVC, action: #selector(menuVC.openCart))
        menuVC.navigationItem.rightBarButtonItem = cartBarItem

        rootViewController.pushViewController(menuVC, animated: true)
    }

    private func showCart(with items: [MenuItem], restaurant: Restaurant) {
        let viewModel = CartViewModel(with: items, restaurant: restaurant)

        let cartVC = CartViewController()
        cartVC.delegate = self
        cartVC.viewModel = viewModel

        rootViewController.pushViewController(cartVC, animated: true)
    }

    @objc private func showOrders() {
        if orderService.orderIds.count == 0 {
            showAlert(title: "No orders", message: "Currently there are no orders available!")
            return
        }

        let orderViewModel = OrderViewModel(with: orderService)
        orderService.getDelegate = orderViewModel

        let orderListVC = OrderListViewController()
        orderViewModel.delegate = orderListVC
        orderListVC.viewModel = orderViewModel
        rootViewController.pushViewController(orderListVC, animated: true)
    }
}

extension AppCoordinator: LoadingManagerDelegate {
    func dataLoaded(with location: CLLocation, and restaurants: [Restaurant]) {
        DispatchQueue.main.async { [weak self] in
            self?.showRestaurants(with: location, and: restaurants)
        }
    }

    func locationDenied() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable Location Services in Settings",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        }
        alert.addAction(okAction)

        rootViewController.present(alert, animated: false)
    }
}

extension AppCoordinator: OrderServicePostDelegate {
    func didFailAddingOrder(error: Error) {
        // TODO: handle error
        print("Error adding the order")
    }
    
    func didSuccessfullyAddOrder(order: OrderGet, for restaurant: Restaurant) {
        cartService.clearCart(for: restaurant.id)
        orderService.push(order: order)

        DispatchQueue.main.async { [weak self] in
            self?.rootViewController.popToRootViewController(animated: false)

            if let count = self?.orderService.orderIds.count {
                self?.ordersBarItem?.title = "Orders(\(count))"
            }
        }
    }
}

extension AppCoordinator: MenuViewControllerDelegate {
    func didClickOpenCart(for restaurant: Restaurant) {

        guard let items = cartService.cart[restaurant.id] else {
            showAlert(title: "Cart is empty", message: "The cart is currently empty")
            return
        }
        showCart(with: items, restaurant: restaurant)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        rootViewController.present(alert, animated: false)
    }

    func didAddToCart(restaurant: Int, menuItem: MenuItem) {
        cartService.add(item: menuItem, for: restaurant)
        guard let count = cartService.cart[restaurant]?.count else {
            return
        }
        cartBarItem?.title = "Cart (\(count))"
    }
}

extension AppCoordinator: CartViewControllerDelegate {
    func didAddOrder(with items: [CartItem], for restaurant: Restaurant) {
        let loadingVC = LoadingViewController()
        loadingVC.navigationItem.hidesBackButton = true
        rootViewController.pushViewController(loadingVC, animated: false)

        orderService.sendOrder(with: items, for: restaurant)
    }

    func didUpdateQuantity(of itemId: Int, to quantity: Int, for restaurantId: Int) {
        cartService.changeQuantity(of: itemId, to: quantity, for: restaurantId)
    }
}

extension AppCoordinator: RestaurantListDelegate {
    func didSelectRestaurant(restaurant: Restaurant) {
        showMenu(restaurant: restaurant)
    }
}
