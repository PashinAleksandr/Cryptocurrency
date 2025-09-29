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

class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let noInternetView = NoInternetView()
    
    var output: CryptocurrencyListViewOutput?
    var cryptos: [Coin] = []
    private var disposeBag = DisposeBag()
    
    private lazy var emptyStateView = ActionView(
        viewModel: ActionViewData(
            title: "Список монет пуст",
            buttonName: "Обновить",
            didTapped: { [weak self] in
                self?.reloadData()
            }
        )
    )

    
    let coin = Coin(capitalization: "250000", changeForDay: 0.5, proposal: 500, changePrice: 23000, confirmationAlgorithm: "ETTPS", price: 25000, hasingAlgorithm: "2fa", fullCoinName: "BissCoin", shortCoinName: "biss", coinId: 1)
    let coin0 = Coin(capitalization: "300000", changeForDay: 50000, proposal: 1000, changePrice: 27000, confirmationAlgorithm: "https", price: 300000, hasingAlgorithm: "SOAP", fullCoinName: "Bitcoin", shortCoinName: "BTC", coinId: 2)
    let coin1 = Coin(capitalization: "1000000000", changeForDay: 10000, proposal: 12341, changePrice: 50000, confirmationAlgorithm: "TSP/ip", price: 150000, hasingAlgorithm: "SOS", fullCoinName: "Ethirium", shortCoinName: "Ethir", coinId: 3)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        title = String.home.firstUppercased()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNoInternetView()
        setupEmptyState()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CryptocurrencyTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        cryptos = [coin, coin0, coin1]

    }
    
    private func setupNoInternetView() {
        view.addSubview(noInternetView)
        noInternetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noInternetView.isHidden = true
        
        noInternetView.retryTap
            .subscribe(onNext: { [weak self] in
                print("Retry tapped in CryptocurrencyListViewController")
                self?.reloadData()
                self?.noInternetView.showLoading()
            })
            .disposed(by: disposeBag)
    }
    
    func setupInitialState() {}
    
    private func setupEmptyState() {
        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        emptyStateView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptocurrencyTableViewCell else {
            return UITableViewCell()
        }
        let crypto = cryptos[indexPath.row]
        cell.configure(with: crypto)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let crypto = cryptos[indexPath.row]
        output?.didselect(coin: crypto)
    }
    
    func showCryptos(_ coins: [Coin]) {
        self.cryptos = coins
        tableView.reloadData()
        
        let hasData = !coins.isEmpty
        tableView.isHidden = !hasData
        emptyStateView.isHidden = hasData
    }
}

extension CryptocurrencyListViewController {
    func checkConnection() {
        let isInternetAvailable = NetworkMonitor.shared.isConnected
        let hasData = !cryptos.isEmpty
        
        if !isInternetAvailable || !hasData {
            noInternetView.isHidden = false
            noInternetView.hideLoading()
        } else {
            noInternetView.isHidden = true
        }
    }
    
    func reloadData() {
        // loading...
        noInternetView.hideLoading()
        noInternetView.isHidden = true
    }
}
