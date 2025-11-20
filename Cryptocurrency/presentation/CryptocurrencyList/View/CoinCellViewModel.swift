
import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

class CoinCellViewModel {
    
    private let coin: Coin
    
    let fullName: Driver<String>
    let shortName: Driver<String>
    private let price: Driver<String>
    let capitalization: Driver<String>
    let dailyChange: Driver<String>
    let iconURL: Driver<URL?>
    
    init(coin: Coin) {
        self.coin = coin
        
        fullName = .just(coin.fullCoinName)
        shortName = .just(coin.shortCoinName)
        price = .just(String(format: "$%.2f", coin.priceRelay.value))
        capitalization = .just(coin.capitalization)
        dailyChange = .just(String(format: "%.2f%%", coin.changeForDay))
        iconURL = .just(coin.iconURL)
    }
}
//TODO: принимать данные, забиндить лейблы и цвета с ячейков (разобраться как это сделать) 
