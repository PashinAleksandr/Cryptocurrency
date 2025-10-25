
import Foundation
import RxSwift
import RxRelay

final class CryptocurrencyListInteractor: CryptocurrencyListInteractorInput {
    
    weak var output: CryptocurrencyListInteractorOutput!
    var coinsService: CoinsServiceProtocol!
    
    private let coinsRelay = BehaviorRelay<[Coin]>(value: [])
    private let disposeBag = DisposeBag()
    
    func subscribeToCoins() {
        coinsService.coins
            .asObservable()
            .subscribe(onNext: { [weak self] newCoins in
                guard let self = self else { return }
                self.updateOldPrices(newCoins: newCoins)
                self.coinsRelay.accept(newCoins)
                self.output?.didUpdateCoins(newCoins)
            })
            .disposed(by: disposeBag)
    }
    
    func loadCoins() {
        coinsService.fetchCoins()
    }
    
    private func updateOldPrices(newCoins: [Coin]) {
        let oldCoins = coinsRelay.value
        
        for newCoin in newCoins {
            if let oldCoin = oldCoins.first(where: { $0.coinId == newCoin.coinId }) {
                newCoin.oldPrice.accept(oldCoin.price)
            } else {
                newCoin.oldPrice.accept(newCoin.price)
            }
        }
    }
}
