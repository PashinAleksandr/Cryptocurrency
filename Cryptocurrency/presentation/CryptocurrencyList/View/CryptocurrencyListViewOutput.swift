
import Foundation

protocol CryptocurrencyListViewOutput: AnyObject {
    func didSelectCoin(_ coin: Coin)
    func loadCoins()
}

