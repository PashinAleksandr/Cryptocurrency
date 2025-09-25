//
//  Coin.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 16.09.2025.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit


class Coin: Codable {
    
    var coinId: Int
    var capitalization: String
    var changeForDay: Double
    var proposal: Double
    var changePrice: Double
    var confirmationAlgorithm: String
    var price: Double
    var hasingAlgorithm: String
    var fullCoinName: String
    var shortCoinName: String
    var iconURL: URL?
    
    init(capitalization: String, changeForDay: Double, proposal: Double, changePrice: Double, confirmationAlgorithm: String, price: Double, hasingAlgorithm: String, fullCoinName: String, shortCoinName: String, iconURL: URL? = nil, coinId: Int) {
        self.capitalization = capitalization
        self.changeForDay = changeForDay
        self.proposal = proposal
        self.changePrice = changePrice
        self.confirmationAlgorithm = confirmationAlgorithm
        self.price = price
        self.hasingAlgorithm = hasingAlgorithm
        self.fullCoinName = fullCoinName
        self.shortCoinName = shortCoinName
        self.iconURL = iconURL
        self.coinId = coinId
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        if lhs.coinId == rhs.coinId {
            return true
        } else {
            return false
        }
    }
}
