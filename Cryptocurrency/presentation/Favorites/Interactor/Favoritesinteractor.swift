
import RxSwift
import Foundation

class FavoritesInteractor: FavoritesInteractorInput {
    
    
    weak var output: FavoritesInteractorOutput!
    var favoritesService: FavoritesServiceProtocol!
    
    private let disposeBag = DisposeBag()
    
    func subscribeToFavorites() {
        favoritesService.favorites
            .asObservable()
            .subscribe(onNext: { [weak self] coins in
                self?.output.didUpdateFavorites(coins: coins)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleFavorite(_ coin: Coin) {
        favoritesService.toggle(coin)
    }
    
    func removeFavorite(_ coin: Coin) {
        favoritesService.remove(coin)
    }
}

