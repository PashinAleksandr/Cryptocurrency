
import Foundation

protocol FavoritesInteractorInput: AnyObject {
    func subscribeToFavorites()
    func removeFavorite(_ coin: Coin)
}

