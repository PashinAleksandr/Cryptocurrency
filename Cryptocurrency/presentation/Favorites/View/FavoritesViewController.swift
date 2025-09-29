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
    
    private lazy var emptyStateView = ActionView(
        viewModel: ActionViewData(
            title: "В избранном пусто",
            buttonName: "Перейти к списку",
            didTapped: { [weak self] in
                self?.output?.didselectCoinListVC()
            }
        )
    )
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupEmptyState()
        
        output?.viewIsReady()
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
    }
    
    private func updateEmptyState() {
        let isEmpty = favorites.isEmpty
        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }
    
    func showFavorites(_ coins: [Coin]) {
        self.favorites = coins
        tableView.reloadData()
        updateEmptyState()
    }
    
    func setupInitialState() {}
    
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
        showModule(usingFactory: factory)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
}
