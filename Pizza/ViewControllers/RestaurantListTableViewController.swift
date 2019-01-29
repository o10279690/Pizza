//
//  RestaurantListTableViewController.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

protocol RestaurantListDelegate: class {
    func didSelectRestaurant(restaurant: Restaurant)
}

class RestaurantListTableViewController: UITableViewController {

    // MARK - Public properties
    var viewModel: RestaurantListViewModel!
    weak var delegate: RestaurantListDelegate?

    // MARK - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(of: RestaurantViewCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: RestaurantViewCell.self)
        cell.configure(with: viewModel.items[indexPath.row], location: viewModel.location)
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRestaurant(restaurant: viewModel.items[indexPath.row])
    }
}
