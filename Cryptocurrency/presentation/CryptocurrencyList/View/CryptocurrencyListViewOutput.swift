
import Foundation

protocol CryptocurrencyListViewOutput: AnyObject {
    func viewIsReady()
    func didSelectCoin(_ coin: Coin)
    func loadCoins()
}

