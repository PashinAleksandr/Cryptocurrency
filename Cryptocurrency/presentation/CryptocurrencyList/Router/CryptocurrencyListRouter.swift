
import Foundation

class CryptocurrencyListRouter: CryptocurrencyListRouterInput {
    weak var transitionHandler: TransitionHandlerProtocol?
    
    func openDetails(for coin: Coin) {
        let factory = DetailsFactory(coin: coin)
        transitionHandler?.showModule(usingFactory: factory)
    }
    
}
