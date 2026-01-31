
import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol FavoritesViewInput: UIViewInput {
    
    func setupInitialState()
    func showFavorites(_ coins: [Coin])
}

