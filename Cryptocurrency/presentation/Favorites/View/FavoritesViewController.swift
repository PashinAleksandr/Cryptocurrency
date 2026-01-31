
import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit
import Kingfisher

class FavoritesViewController: UIViewController, FavoritesViewInput, UITableViewDelegate, UITableViewDataSource {
    
    var output: FavoritesViewOutput?
    private let tableView = UITableView()
    private var favorites: [Coin] = []
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let noInternetView = NoInternetView()
    private var coinsViewModels: [CryptocurrencyTableViewCell.ViewModel] = []

    
    private lazy var emptyStateView = ActionView(
        viewModel: ActionView.ViewModel(
            title: "В избранном пусто",
            buttonName: "Перейти к списку Криптовалют",
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
        setupRefreshControl()
        setupNetworkMonitor()
        setupActivityIndicator()
        activityIndicator.stopAnimating()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    
    @objc private func handleRefresh() {
        tableView.reloadData()
    }
    
    private func setupNetworkMonitor() {
        NetworkMonitor.shared.isConnectedRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isConnected in
                guard let self = self else { return }
                self.noInternetView.isHidden = isConnected
                if isConnected {
                    tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
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
    
    func changingCellVIewModel(newCoins: [Coin]) {
        for newCoin in newCoins {
            if let index = favorites.firstIndex(where: { $0.coinId == newCoin.coinId }) {
                let oldCoin = favorites[index]
                if oldCoin.priceRelay.value != newCoin.priceRelay.value {
                    oldCoin.priceRelay.accept(newCoin.priceRelay.value)
                    oldCoin.changeForDay = newCoin.changeForDay
                    oldCoin.capitalization = newCoin.capitalization
                    oldCoin.changePrice = newCoin.changePrice
                }
            } else {
                favorites.append(newCoin)
            }
        }
        
        favorites.removeAll { oldCoin in
            !newCoins.contains(where: { $0.coinId == oldCoin.coinId })
        }
        
        var updatedViewModels: [CryptocurrencyTableViewCell.ViewModel] = []
        
        for favorit in favorites {
            if let existingVM = coinsViewModels.first(where: { $0.id.value == favorit.coinId }) {
                existingVM.fullName.accept(favorit.fullCoinName)
                existingVM.shortName.accept(favorit.shortCoinName)
                existingVM.price.accept(favorit.priceRelay.value.description)
                existingVM.capitalization.accept(favorit.capitalization)
                existingVM.dailyChange.accept(favorit.changeForDay)
                updatedViewModels.append(existingVM)
                
            } else {
                let newVM = CryptocurrencyTableViewCell.ViewModel(coin: favorit)
                updatedViewModels.append(newVM)
            }
        }
        coinsViewModels = updatedViewModels
    }
    
    private func updateEmptyState() {
        let isEmpty = favorites.isEmpty
        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
    }
    
    func showFavorites(_ coins: [Coin]) {
        self.favorites = coins
        changingCellVIewModel(newCoins: self.favorites)
        tableView.reloadData()
        updateEmptyState()
    }
    
    func setupInitialState() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CryptocurrencyTableViewCell.self, indexPath: indexPath)
        let vm = coinsViewModels[indexPath.row]
        cell.configure(with: vm)
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
        let favoritesService = MainModuleAssembler.resolver.resolve(FavoritesServiceProtocol.self)!
        
        favoritesService.favorites
            .subscribe(onNext: { [weak self] favorites in
                guard let self = self else { return }
                self.favorites = favorites
            })
            .disposed(by: disposeBag)
    }
}
