//
//  FavoritesViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

class FavoritesViewController: UIViewController, FavoritesViewInput, UITableViewDelegate, UITableViewDataSource {
    
    var output: FavoritesViewOutput?
    private let tableView = UITableView()
    private var favorites: [Coin] = []
    private let disposeBag = DisposeBag()
    
    // вынеси в отдельный класс и присвой сюда готовую вью
    private let emptyStateView = UIView()
    private let emptyLabel = UILabel()
    private let addButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        title = "Избранное"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupEmptyState()
        updateEmptyState()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CryptocurrencyTableViewCell.self)
    }
    
    private func setupEmptyState() {
        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        emptyLabel.text = "Добавить в избранное?"
        emptyLabel.textAlignment = .center
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        emptyStateView.addSubview(emptyLabel)
        emptyStateView.addSubview(addButton)
        
        emptyLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.output?.didselectCoinListVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateEmptyState() {
        let isEmpty = favorites.isEmpty
        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }
    
    private func navigateToCryptoList() {
        let vc = CryptocurrencyListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    func showFavorites(_ coins: [Coin]) {
        self.favorites = coins
        tableView.reloadData()
        updateEmptyState()
    }
    
    func setupInitialState() { }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CryptocurrencyTableViewCell.self, indexPath: indexPath) 
        let crypto = favorites[indexPath.row]
        cell.configure(with: crypto)
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = favorites[indexPath.row]
        
        let factory = DetailsFactory(coin: coin)
        self.showModule(usingFactory: factory)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else { return }
            let coin = self.favorites[indexPath.row]
            self.output?.didRemoveFavorite(coin)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
