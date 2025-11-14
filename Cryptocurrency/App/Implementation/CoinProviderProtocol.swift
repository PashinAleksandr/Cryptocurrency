

import Foundation

protocol CoinProviderProtocol {
    func fetchCoins(by ids: [Int], completion: @escaping ([Coin]) -> Void)
    
}
