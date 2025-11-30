
import Foundation
import RxSwift
import RxRelay

final class CryptocurrencyListInteractor: CryptocurrencyListInteractorInput {
    
    weak var output: CryptocurrencyListInteractorOutput!
    var coinsService: CoinsServiceProtocol!
    
    private let disposeBag = DisposeBag()
    
    func subscribeToCoins() {
        coinsService.coins
            .asObservable()
            .subscribe(onNext: { [weak self] newCoins in
            })
            .disposed(by: disposeBag)
    }
    
    func loadCoins() {
        
        coinsService.fetchCoins { [weak self] coins, error in
            guard let self = self else { return }
            if let coins = coins {
                self.output.didUpdateCoins(coins)
            }
            
            if let error = error {
                output.showError(error: error)
            }
        }
    }
}
