
import Foundation

class FavoritesPresenter: NSObject, FavoritesModuleInput, FavoritesViewOutput {
    weak var view: FavoritesViewInput!
    var interactor: FavoritesInteractorInput!
    var router: FavoritesRouterInput!
    
    func didUpdateFavorites(coins: [Coin]) {
        view.showFavorites(coins)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.subscribeToFavorites()
    }
    
    func didselectCoinListVC() {
        router.openCryprocurrenctList()
    }
    
    func didRemoveFavorite(_ coin: Coin) {
        interactor.removeFavorite(coin)
    }
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    
}

