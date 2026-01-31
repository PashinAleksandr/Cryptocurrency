
import Foundation
import RxSwift

protocol CryptocurrencyListInteractorOutput: AnyObject {
    func didUpdateCoins(_ coins: [Coin])
    func showError(error: Error)
}
