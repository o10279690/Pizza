//
//  MenuViewController.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func didAddToCart(restaurant: Int, menuItem: MenuItem)
    func didClickOpenCart(for restaurant: Restaurant)
}

class MenuViewController: UIViewController {

    // MARK - Public properties
    var viewModel: MenuViewModel!
    weak var delegate: MenuViewControllerDelegate?

    // MARK - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        title = viewModel.restaurant.name

        self.view.addSubview(tableView)

        tableView.backgroundView = activityView
        activityView.startAnimating()

        viewModel.loadMenu()
    }

    // MARK - Public methods
    @objc func openCart() {
        delegate?.didClickOpenCart(for: viewModel.restaurant)
    }

    // MARK: - Private properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(in: view)
        tableView.register(of: MenuItemViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        return activityView
    }()
}

// MARK: - UITableViewDataSource & UITableViewDelegate methods
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MenuItemViewCell.self)
        cell.delegate = self
        cell.configure(model: viewModel.items[indexPath.section].items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.items[section].category
    }
}

// MARK: - MenuViewModelDelegate methods
extension MenuViewController: MenuViewModelDelegate {
    func didLoadMenu() {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stopAnimating()
            self?.tableView.separatorStyle = .singleLine
            self?.tableView.reloadData()
        }
    }
}

// MARK: - MenuItemViewCellDelegate methods
extension MenuViewController: MenuItemViewCellDelegate {
    func didAddToCart(menuItem: MenuItem) {
        delegate?.didAddToCart(restaurant: viewModel.restaurant.id, menuItem: menuItem)
    }
}
