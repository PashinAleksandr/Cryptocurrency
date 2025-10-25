
import Foundation
import RxSwift
import RxRelay

protocol FavoritesServiceProtocol: AnyObject {
    
    var favorites: BehaviorRelay<[Coin]> { get }
    
    func add(_ coin: Coin)
    func remove(_ coin: Coin)
    func toggle(_ coin: Coin)
    func isFavorite(_ coin: Coin) -> Bool
    
}
