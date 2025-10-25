
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CryptocurrencyListViewController: UIViewController, CryptocurrencyListViewInput {
    
    var output: CryptocurrencyListViewOutput!
    
    private let tableView = UITableView()
    private var coins: [Coin] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        output.viewIsReady()
    }
    
    func setupInitialState() {
        tableView.reloadData()
    }
    
    func showCoins(_ coins: [Coin]) {
        self.coins = coins
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        output.loadCoins()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setupUI() {
        title = "Cryptocurrencies"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptocurrencyTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.refreshControl = refreshControl
    }
}

extension CryptocurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { coins.count }
    
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
