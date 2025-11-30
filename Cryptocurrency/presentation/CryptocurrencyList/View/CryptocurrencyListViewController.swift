
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput {
    
    var output: CryptocurrencyListViewOutput!
    
    private let tableView = UITableView()
    private var coins: [Coin] = []
    private var coinsViewModels: [CryptocurrencyTableViewCell.ViewModel] = []
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let noInternetView = NoInternetView()
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        setupNetworkMonitor()
        setupActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func changingCellVIewModel(newCoins: [Coin]) {
        for newCoin in newCoins {
            if let index = coins.firstIndex(where: { $0.coinId == newCoin.coinId }) {
                let oldCoin = coins[index]
                if oldCoin.priceRelay.value != newCoin.priceRelay.value {
                    oldCoin.priceRelay.accept(newCoin.priceRelay.value)
                    oldCoin.changeForDay = newCoin.changeForDay
                    oldCoin.capitalization = newCoin.capitalization
                    oldCoin.changePrice = newCoin.changePrice
                }
            } else {
                coins.append(newCoin)
            }
        }
        
        coins.removeAll { oldCoin in
            !newCoins.contains(where: { $0.coinId == oldCoin.coinId })
        }
        
        var updatedViewModels: [CryptocurrencyTableViewCell.ViewModel] = []
        
        for coin in coins {
            if let existingVM = coinsViewModels.first(where: { $0.id.value == coin.coinId }) {
                existingVM.fullName.accept(coin.fullCoinName)
                existingVM.shortName.accept(coin.shortCoinName)
                existingVM.price.accept(coin.priceRelay.value.description)
                existingVM.capitalization.accept(coin.capitalization)
                existingVM.dailyChange.accept(coin.changeForDay)
                
                updatedViewModels.append(existingVM)
                
            } else {
                let newVM = CryptocurrencyTableViewCell.ViewModel(coin: coin)
                updatedViewModels.append(newVM)
            }
        }
        coinsViewModels = updatedViewModels
    }
    
    func setupInitialState() {
        tableView.reloadData()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private var doOnce: Bool = false
    
    func showCoins(_ coins: [Coin]) {
        self.coins = coins
        changingCellVIewModel(newCoins: self.coins)
        refreshControl.endRefreshing()
        stopActivityIndicator()
        setupInitialState()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        output.loadCoins()
    }
    
    private func setupNetworkMonitor() {
        NetworkMonitor.shared.isConnectedRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isConnected in
                guard let self = self else { return }
                self.noInternetView.isHidden = isConnected
                if isConnected {
                    self.output.loadCoins()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        title = "Cryptocurrencies"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptocurrencyTableViewCell.self)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.refreshControl = refreshControl
        
        view.addSubview(noInternetView)
        noInternetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noInternetView.isHidden = true
        
        noInternetView.retryTap
            .bind { [weak self] in
                guard let self = self else { return }
                if NetworkMonitor.shared.isConnected {
                    self.output.loadCoins()
                }
            }
            .disposed(by: disposeBag)
    }
}


extension CryptocurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coinsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CryptocurrencyTableViewCell.self, indexPath: indexPath)
        let vm = coinsViewModels[indexPath.row]
        cell.configure(with: vm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = coins[indexPath.row]
        output.didSelectCoin(coin)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
