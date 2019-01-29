//
//  MenuItemViewCell.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/28/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

protocol MenuItemViewCellDelegate: class {
    func didAddToCart(menuItem: MenuItem)
}

class MenuItemViewCell: UITableViewCell {

    // MARK: - Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK - Public properties
    weak var delegate: MenuItemViewCellDelegate?

    // MARK: - Public methods
    func configure(model: MenuItem) {
        self.menuItem = model

        nameLabel.text = model.name
        // TODO: create an extension for currency formatter
        priceLabel.text = "\(model.price) SEK"
        if let topping = model.topping {
            toppingLabel.isHidden = false
            toppingLabel.text = topping.joined(separator: ", ")
        } else {
            toppingLabel.isHidden = true
        }
    }

    // MARK: - Private properties
    private var menuItem: MenuItem?

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var toppingLabel: UILabel!

    // MARK: - IBActions
    @IBAction func addToCart(_ sender: Any) {
        guard let menuItem = menuItem else {
            return
        }
        delegate?.didAddToCart(menuItem: menuItem)
    }
}
