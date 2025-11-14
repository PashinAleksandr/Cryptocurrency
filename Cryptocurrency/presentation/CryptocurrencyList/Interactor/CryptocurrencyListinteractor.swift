
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
                self?.output?.didUpdateCoins(newCoins)
            })
            .disposed(by: disposeBag)
    }
    
    func loadCoins() {
        //        coinsService.fetchCoins()
        //            .subscribe(
        //                onSuccess: { [weak self] coins in
        //                    self?.output?.didUpdateCoins(coins)
        //                },
        //                onFailure: { error in
        //                    print("Ошибка загрузки: \(error)")
        //                }
        //            )
        //            .disposed(by: disposeBag)
        
        
        coinsService.fetchCoins2 { coins, error in
            if let coins = coins {
                self.output.didUpdateCoins(coins)
            }
            if let error = error {
                print(error)
            }
        }
        
        coinsService.fetchCoins2 { [weak self] coins, error in
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
