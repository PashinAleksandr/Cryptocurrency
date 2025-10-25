
import Foundation
import ObjectMapper
import RxSwift
import RxRelay

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
    var oldPrice = BehaviorRelay<Double?>(value: nil)
    
    init() {}
    
    required init?(map: Map) { }
    
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
           self.oldPrice.accept(price)
       }
    
    func mapping(map: Map) {
        let stringToInt = TransformOf<Int, Any>(fromJSON: { value in
            if let v = value as? Int { return v }
            if let s = value as? String, let i = Int(s) { return i }
            return nil
        }, toJSON: { $0 })
        
        let stringToDouble = TransformOf<Double, Any>(fromJSON: { value in
            if let v = value as? Double { return v }
            if let v = value as? Int { return Double(v) }
            if let s = value as? String, let d = Double(s) { return d }
            return nil
        }, toJSON: { $0 })
        
        coinId <- (map["ID"], stringToInt)
        if coinId == 0 { coinId <- (map["id"], stringToInt) }
        
        fullCoinName <- map["NAME"]
        if fullCoinName.isEmpty { fullCoinName <- map["name"] }
        
        shortCoinName <- map["SYMBOL"]
        if shortCoinName.isEmpty { shortCoinName <- map["symbol"] }
        
        price <- (map["PRICE_USD"], stringToDouble)
        if price == 0 { price <- (map["priceUsd"], stringToDouble) }
        oldPrice.accept(price)
        
        var cap: Double = 0
        cap <- (map["TOTAL_MKT_CAP_USD"], stringToDouble)
        if cap == 0 { cap <- (map["CIRCULATING_MKT_CAP_USD"], stringToDouble) }
        capitalization = "\(cap)"
        
        changeForDay <- (map["SPOT_MOVING_24_HOUR_CHANGE_PERCENTAGE_USD"], stringToDouble)
        if changeForDay == 0 {
            changeForDay <- (map["SPOT_MOVING_7_DAY_CHANGE_PERCENTAGE_USD"], stringToDouble)
        }
        
        proposal <- (map["SUPPLY_FUTURE"], stringToDouble)
        if proposal <= 0 { proposal <- (map["SUPPLY_TOTAL"], stringToDouble) }
        
        changePrice <- (map["PRICE_CONVERSION_VALUE"], stringToDouble)
        
        confirmationAlgorithm <- map["ASSET_DESCRIPTION_SNIPPET"]
        hasingAlgorithm <- map["ASSET_TYPE"]
        
        iconURL <- (map["LOGO_URL"], URLTransform())
        if iconURL == nil { iconURL <- (map["logo_url"], URLTransform()) }
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.coinId == rhs.coinId
    }
}
