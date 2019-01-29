//
//  UITableView+Extensions.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/29/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

extension UITableView {
    convenience init(in view: UIView) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let displayWidth = view.frame.width
        let displayHeight = view.frame.height
        let rect = CGRect(x: 0, y: statusBarHeight, width: displayWidth, height: displayHeight - statusBarHeight)
        self.init(frame: rect)
    }

    func dequeueCell<T: UITableViewCell>(of type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }

    func dequeueCell<T: UITableViewCell>(of type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func register<T: UITableViewCell>(of type: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
}
