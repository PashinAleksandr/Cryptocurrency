//
//  CryptocurrencyListViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

import UIKit

final class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput {
    
    var output: CryptocurrencyListViewOutput!
    
    private let tableView = UITableView()
    private var coins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewIsReady()
    }
    
    // MARK: - ViewInput
    
    func setupInitialState() {
        tableView.reloadData()
    }
    
    func showCoins(_ coins: [Coin]) {
        self.coins = coins
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI
    
    private func setupUI() {
        title = "Cryptocurrencies"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptocurrencyTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CryptocurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CryptocurrencyTableViewCell else {
            return UITableViewCell()
        }
        let coin = coins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = coins[indexPath.row]
        output.didSelectCoin(coin)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



