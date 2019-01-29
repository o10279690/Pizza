//
//  CartItemViewCell.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

protocol CartItemViewCellDelegate: class {
    func quantityUpdated(to quantity: Int, for item: CartItem)
}

class CartItemViewCell: UITableViewCell {

    // MARK: - Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()

        quantityStepper.minimumValue = 1.0
        quantityStepper.maximumValue = 9.0
        quantityStepper.stepValue = 1.0
    }

    // MARK - Public properties
    weak var delegate: CartItemViewCellDelegate?

    // MARK: - Public methods
    func configure(model: CartItem) {
        cartItem = model
        quantityStepper.value = Double(model.quantity)
        quantity = model.quantity
        nameLabel.text = model.item.name
        priceLabel.text = "\(model.item.price) SEK"
        updateQuantity()
    }

    // MARK: - Private properties
    private var cartItem: CartItem?
    private var quantity: Int = 0

    // MARK: - Private methods
    private func updateQuantity() {
        quantityLabel.text = "Qt: \(quantity)"
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityStepper: UIStepper!

    // MARK: - IBActions
    @IBAction func quantityStepper(_ sender: UIStepper) {
        guard let cartItem = cartItem else {
            return
        }
        quantity = Int(sender.value)
        updateQuantity()

        delegate?.quantityUpdated(to: quantity, for: cartItem)
    }
}
