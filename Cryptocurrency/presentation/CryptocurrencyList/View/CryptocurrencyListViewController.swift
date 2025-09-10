//
//  CryptocurrencyListViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import UIKit

class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput {

    var output: CryptocurrencyListViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: CryptocurrencyListViewInput
    func setupInitialState() {
    }
}
