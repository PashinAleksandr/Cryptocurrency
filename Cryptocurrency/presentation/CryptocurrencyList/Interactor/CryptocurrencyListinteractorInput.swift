
import Foundation
import RxSwift

protocol CryptocurrencyListInteractorInput: AnyObject {
    func subscribeToCoins()
    func loadCoins()
}
