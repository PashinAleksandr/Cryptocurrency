
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput {
    
    var output: CryptocurrencyListViewOutput!
    
    private let tableView = UITableView()
    private var coins: [Coin] = []
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
        output.viewIsReady()
        setupActivityIndicator()
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
    
    func setupInitialState() {
        tableView.reloadData()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private var doOnce: Bool = false
    
    func showCoins(_ coins: [Coin]) {
        //TODO: обновлять массив viewModels перезаполнять.
        self.coins = coins
        if !doOnce {
            self.tableView.reloadData()
            doOnce = true
        }
        refreshControl.endRefreshing()
        stopActivityIndicator()
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
                    // TODO: ошибка повторно вызываем запрос у ссерверва (первый раз в viewdidload)
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
        coins.count
    }
    //TODO: Заполнять массивом viewModels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CryptocurrencyTableViewCell.self, indexPath: indexPath)
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
