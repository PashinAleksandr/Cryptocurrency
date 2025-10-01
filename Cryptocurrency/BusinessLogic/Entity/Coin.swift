//
//  Coin.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 16.09.2025.
//

import Foundation
import UIKit
import ObjectMapper

class Coin: Mappable {
    
    var coinId: Int = 0
    var capitalization: String = ""
    var changeForDay: Double = 0
    var proposal: Double = 0
    var changePrice: Double = 0
    var confirmationAlgorithm: String = ""
    var price: Double = 0
    var hasingAlgorithm: String = ""
    var fullCoinName: String = ""
    var shortCoinName: String = ""
    var iconURL: URL?
    
    // стандартный инициализатор (если нужен вручную)
    init(capitalization: String,
         changeForDay: Double,
         proposal: Double,
         changePrice: Double,
         confirmationAlgorithm: String,
         price: Double,
         hasingAlgorithm: String,
         fullCoinName: String,
         shortCoinName: String,
         iconURL: URL? = nil,
         coinId: Int) {
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
    
    // MARK: - Mappable
    required init?(map: Map) {
        // можно оставить пустым — значения проставятся в mapping
    }
    
    func mapping(map: Map) {
        // API иногда возвращает id как String, иногда как Int.
        // используем TransformOf чтобы парсить "123" -> Int(123) и Int -> String при обратной сериализации
        let stringToIntTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            guard let v = value else { return nil }
            return Int(v)
        }, toJSON: { (value: Int?) -> String? in
            guard let v = value else { return nil }
            return String(v)
        })
        
        // пробуем сначала строковый id -> int
        coinId                  <- (map["id"], stringToIntTransform)
        // если API отдаёт id как Int (не строкой), ObjectMapper выше не сработает — пробуем также обычный Int mapping
        if coinId == 0 {
            coinId <- map["id"]
        }
        
        fullCoinName            <- map["name"]
        shortCoinName           <- map["symbol"]
        
        // некоторые поля могут быть строки в API, поэтому используем временные переменные и конвертации при необходимости
        // price и прочие ожидаем как Double
        price                   <- map["priceUsd"]     // coincap sample key
        capitalization          <- map["marketCapUsd"] // coincap sample key
        changeForDay            <- map["changePercent24Hr"] // coincap sample key
        proposal                <- map["supply"]       // coincap sample key
        // Если у тебя другие ключи — поправь ключи под реальный API.
        
        // если в другом API используются другие ключи (например "price_usd"), добавь альтернативы:
        if price == 0 {
            price <- map["price_usd"]
        }
        if capitalization.isEmpty {
            capitalization <- map["market_cap_usd"]
        }
        if changeForDay == 0 {
            changeForDay <- map["percent_change_24h"]
        }
        if proposal == 0 {
            proposal <- map["total_supply"]
        }
        
        // Остальные (если есть)
        changePrice             <- map["change_price"]
        confirmationAlgorithm   <- map["confirmation_algorithm"]
        hasingAlgorithm         <- map["hashing_algorithm"]
        iconURL                 <- (map["icon"], URLTransform())
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.coinId == rhs.coinId
    }
}
