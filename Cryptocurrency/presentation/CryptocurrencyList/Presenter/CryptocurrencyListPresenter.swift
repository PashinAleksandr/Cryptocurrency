
import Foundation

final class CryptocurrencyListPresenter: CryptocurrencyListViewOutput, CryptocurrencyListInteractorOutput {
    weak var view: CryptocurrencyListViewInput!
    var interactor: CryptocurrencyListInteractorInput!
    var router: CryptocurrencyListRouterInput!
    
    func loadCoins() {
        interactor.loadCoins()
    }
    
    func didSelectCoin(_ coin: Coin) {
        router.openDetails(for: coin)
    }
    
    func showError(error: Error) {
        view.show(error)
    }
    
    func didUpdateCoins(_ coins: [Coin]) {
        view.showCoins(coins)
    }
}
