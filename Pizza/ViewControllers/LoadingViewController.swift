//
//  LoadingViewController.swift
//  Pizza
//
//  Created by Ioannis Diamantidis on 1/27/19.
//  Copyright © 2019 Ioannis Diamantidis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    // MARK - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        addSpinner()
    }

    // MARK - Private methods
    private func addSpinner() {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()

        self.view.addSubview(activityView)
    }
}
