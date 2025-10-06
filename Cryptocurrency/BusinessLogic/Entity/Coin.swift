//
//  Coin.swift
//  Cryptocurrency
//

import Foundation
import ObjectMapper

final class Coin: Mappable {
    
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
    
    init() {}
    
    init(capitalization: String = "",
         changeForDay: Double = 0,
         proposal: Double = 0,
         changePrice: Double = 0,
         confirmationAlgorithm: String = "",
         price: Double = 0,
         hasingAlgorithm: String = "",
         fullCoinName: String = "",
         shortCoinName: String = "",
         iconURL: URL? = nil,
         coinId: Int = 0) {
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
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        let stringToInt = TransformOf<Int, Any>(fromJSON: { (value: Any?) -> Int? in
            if let v = value as? Int { return v }
            if let s = value as? String { return Int(s) }
            return nil
        }, toJSON: { (value: Int?) -> Any? in
            return value
        })
        
        let stringToDouble = TransformOf<Double, Any>(fromJSON: { (value: Any?) -> Double? in
            if let v = value as? Double { return v }
            if let v = value as? Int { return Double(v) }
            if let s = value as? String { return Double(s) }
            return nil
        }, toJSON: { (value: Double?) -> Any? in
            return value
        })
        
        coinId                  <- (map["ID"], stringToInt)
        if coinId == 0 {
            coinId <- (map["id"], stringToInt)
        }
        
        fullCoinName            <- map["NAME"]
        if fullCoinName.isEmpty { fullCoinName <- map["name"] }
        
        shortCoinName           <- map["SYMBOL"]
        if shortCoinName.isEmpty { shortCoinName <- map["symbol"] }
        
        price                   <- (map["PRICE_USD"], stringToDouble)
        if price == 0 { price <- (map["PRICE_USD"], stringToDouble) }
        
        capitalization          <- map["TOTAL_MKT_CAP_USD"]
        if capitalization.isEmpty { capitalization <- map["TOTAL_MKT_CAP_USD"] }
        
        changeForDay            <- (map["SPOT_MOVING_7_DAY_CHANGE_PERCENTAGE_USD"], stringToDouble)
        if changeForDay == 0 { changeForDay <- (map["SPOT_MOVING_24_HOUR_CHANGE_PERCENTAGE_USD"], stringToDouble) }
        if changeForDay == 0 { changeForDay <- (map["changePercent24Hr"], stringToDouble) }
        
        proposal                <- (map["SUPPLY_FUTURE"], stringToDouble)
        if proposal == 0 { proposal <- (map["SUPPLY_TOTAL"], stringToDouble) }
        
        changePrice             <- (map["PRICE_CONVERSION_VALUE"], stringToDouble)
        confirmationAlgorithm   <- map["ASSET_DESCRIPTION_SNIPPET"]
        hasingAlgorithm         <- map["ASSET_TYPE"]
        
        iconURL                 <- (map["LOGO_URL"], URLTransform())
        if iconURL == nil {
            iconURL <- (map["logo_url"], URLTransform())
        }
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.coinId == rhs.coinId
    }
}
