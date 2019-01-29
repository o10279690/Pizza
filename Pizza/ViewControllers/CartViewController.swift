//
//  CartViewController.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

protocol CartViewControllerDelegate: class {
    func didUpdateQuantity(of itemId: Int, to quantity: Int, for restaurantId: Int)
    func didAddOrder(with items: [CartItem], for restaurant: Restaurant)
}

class CartViewController: UIViewController {

    // MARK - Public properties
    var viewModel: CartViewModel!
    weak var delegate: CartViewControllerDelegate?

    // MARK - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        self.view.addSubview(footerView)
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        footerView.addSubview(button)
        button.fill(view: footerView)

        tableView.register(of: CartItemViewCell.self)
    }

    // MARK: - Private properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var footerView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor.veryLightGrey
        return customView
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Order now (\(viewModel.amount) SEK)", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Private methods
    @objc private func buttonAction(_ sender: UIButton!) {
        delegate?.didAddOrder(with: viewModel.cartItems, for: viewModel.restaurant)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate methods
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: CartItemViewCell.self)
        let cartItem = viewModel.cartItems[indexPath.row]
        cell.delegate = self
        cell.configure(model: cartItem)
        return cell
    }
}

// MARK: - CartItemViewCellDelegate methods
extension CartViewController: CartItemViewCellDelegate {
    func quantityUpdated(to quantity: Int, for item: CartItem) {
        viewModel.changeQuantity(of: item, to: quantity)
        delegate?.didUpdateQuantity(of: item.id, to: quantity, for: viewModel.restaurant.id)
        button.setTitle("Order now (\(viewModel.amount) SEK)", for: .normal)
        button.setNeedsLayout()
    }
}
