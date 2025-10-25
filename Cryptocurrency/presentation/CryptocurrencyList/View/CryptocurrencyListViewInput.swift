
import Foundation

protocol CryptocurrencyListViewInput: UIViewInput {
    func setupInitialState()
    func showCoins(_ coins: [Coin])
}
