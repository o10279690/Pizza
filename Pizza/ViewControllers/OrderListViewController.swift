//
//  OrderListViewController.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {

    // MARK - Public properties
    var viewModel: OrderViewModel!

    // MARK - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(in: view)
        tableView.register(of: OrderDetailsViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center

        tableView.backgroundView = activityView

        activityView.startAnimating()
        tableView.separatorStyle = .none

        viewModel.loadOrders()
    }

    // MARK: - Private properties
    private var tableView: UITableView!
    private var activityView: UIActivityIndicatorView!
}

// MARK: - UITableViewDataSource & UITableViewDelegate methods
extension OrderListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: OrderDetailsViewCell.self)
        let order = viewModel.orders[indexPath.row]
        cell.configure(model: order)
        return cell
    }
}

// MARK: - OrderViewModelDelegate methods
extension OrderListViewController: OrderViewModelDelegate {
    func didLoadOrders() {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stopAnimating()
            self?.tableView.separatorStyle = .singleLine
            self?.tableView.reloadData()
        }
    }
}
