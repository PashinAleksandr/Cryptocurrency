
import RxSwift
import RxRelay
import RxCocoa
import Foundation

class FavoritesService: FavoritesServiceProtocol {
    
    private let storageKey = "favorites.coinIds"
    internal let favorites = BehaviorRelay<[Coin]>(value: [])
    private let disposeBag = DisposeBag()
    private let coinProvider: CoinProviderProtocol
    var coins: [Coin] = []
    
    init(coinProvider: CoinProviderProtocol) {
        self.coinProvider = coinProvider
        getCoins()
    }
    
    private func getCoins() {
        if let coinsService = MainModuleAssembler.resolver.resolve(CoinsServiceProtocol.self) {
            coinsService.coins
                .subscribe(onNext: { [weak self] coins in
                    guard let self = self else { return }
                    self.coins = coins
                    let filteredCoins = coins.filter { self.loadIds().contains($0.coinId) }
                    favorites.accept(filteredCoins)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func add(_ coin: Coin) {
        var currentIds = loadIds()
        guard !currentIds.contains(coin.coinId) else { return }
        currentIds.append(coin.coinId)
        saveIds(currentIds)
        
        var currentCoins = favorites.value
        currentCoins.append(coin)
        favorites.accept(currentCoins)
    }
    
    func remove(_ coin: Coin) {
        var currentIds = loadIds()
        currentIds.removeAll { $0 == coin.coinId }
        saveIds(currentIds)
        
        var currentCoins = favorites.value
        currentCoins.removeAll { $0.coinId == coin.coinId }
        favorites.accept(currentCoins)
    }
    
    func toggle(_ coin: Coin) {
        if isFavorite(coin) {
            remove(coin)
        } else {
            add(coin)
        }
    }
    
    func isFavorite(_ coin: Coin) -> Bool {
        return loadIds().contains(coin.coinId)
    }
    
    private func saveIds(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: storageKey)
    }
    
    private func loadIds() -> [Int] {
        return UserDefaults.standard.array(forKey: storageKey) as? [Int] ?? []
    }
}

class MockCoinProvider: CoinProviderProtocol {
    func fetchCoins(by ids: [Int], completion: @escaping ([Coin]) -> Void) {
        let mockCoins = [
            Coin(capitalization: "123", changeForDay: 1.2, proposal: 12345,
                 changePrice: 100, confirmationAlgorithm: "PoW",
                 price: 1500, hasingAlgorithm: "SHA-256",
                 fullCoinName: "Ethereum", shortCoinName: "ETH", coinId: 0)
        ]
        completion(mockCoins)
    }
}

class CoinProvider: CoinProviderProtocol {
    
    func fetchCoins(by ids: [Int], completion: @escaping ([Coin]) -> Void) {
        
    }
}

