//
//  UIButton+Extensions.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

extension UIButton {
    func fill(view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
