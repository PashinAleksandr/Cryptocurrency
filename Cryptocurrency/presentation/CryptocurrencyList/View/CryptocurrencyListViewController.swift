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
    var output: CryptocurrencyListViewOutput?
    var cryptos: [Coin] = []
    private var disposeBag = DisposeBag()
    
    var eth:Coin = Coin(capitalization: "daegag", changeForDay: 2.532, proposal: 1245215.1, changePrice: 12451, confirmationAlgorithm: "fsf", price: 124, hasingAlgorithm: "afe", fullCoinName: "eth", shortCoinName: "e", coinId: 0)
    var sam:Coin = Coin(capitalization: "adfgweg", changeForDay: 467, proposal: 90983465, changePrice: 25436, confirmationAlgorithm: "kookrgnjogs", price: 34647574, hasingAlgorithm: "okngnjg", fullCoinName: "samthing", shortCoinName: "sam", coinId: 1)
    var test:Coin = Coin(capitalization: "iusaoiufa", changeForDay: 90781234, proposal: 967345, changePrice: 7142839, confirmationAlgorithm: "lvhjfsdhvs", price: 79854, hasingAlgorithm: "ohjpefohi[efw[o", fullCoinName: "test124", shortCoinName: "test", coinId: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        title = String.home.firstUppercased()
        view.backgroundColor = .systemBackground
        setupTableView()
        
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CryptocurrencyTableViewCell.self, forCellReuseIdentifier: "CryptoCell")
        cryptos = [eth, sam, test]
    }
    
    func setupInitialState() {
        
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
    
}

extension CryptocurrencyListViewController {
    func checkConnection() {
        let isInternetAvailable = NetworkMonitor.shared.isConnected // пример
        let hasData = !cryptos.isEmpty
        
        if !isInternetAvailable || !hasData {
            let noInternetVC = NoInternetViewController()
            
            noInternetVC.retryTap.subscribe(onNext: { [weak self] in
                self?.reloadData()
            }).disposed(by: disposeBag)
            
            present(noInternetVC, animated: true)
        }
    }
    
    func reloadData() {
        // Здесь снова дергаем сервер или делаем повторный запрос
        dismiss(animated: true) // убираем экран если данные появились
    }
}
