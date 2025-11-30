
import Foundation
import ObjectMapper
import RxSwift
import RxRelay


final class Coin: Mappable {
    
    var dispostBag: DisposeBag = DisposeBag()
    var coinId: Int = 0
    var capitalization: String = ""
    var changeForDay: Double = 0
    var proposal: Double = 0
    var changePrice: Double = 0
    var confirmationAlgorithm: String = ""
    var hasingAlgorithm: String = ""
    var fullCoinName: String = ""
    var shortCoinName: String = ""
    var iconURL: URL?
    var oldPrice: Double?
    var priceRelay = BehaviorRelay<Double>(value: 0) 
    var price: Double = 0
    
    init() {
    }
    
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
        
        priceRelay.subscribe { [weak self] value in
            self?.oldPrice = value
            
        }.disposed(by: dispostBag)
    }
   
    func mapping(map: Map) {
        let stringToInt = TransformOf<Int, Any>(fromJSON: { value in
            if let v = value as? Int { return v }
            return nil
        }, toJSON: { $0 })
        
        let stringToDouble = TransformOf<Double, Any>(fromJSON: { value in
            if let v = value as? Double { return v }
            return nil
        }, toJSON: { $0 })
        
        coinId <- (map["ID"], stringToInt)
        
        fullCoinName <- map["NAME"]
        
        shortCoinName <- map["SYMBOL"]

        price <- (map["PRICE_USD"], stringToDouble)
        priceRelay.accept(price)

        var cap: Double = 0
        cap <- (map["TOTAL_MKT_CAP_USD"], stringToDouble)
        capitalization = "\(cap)"
        
        changeForDay <- (map["SPOT_MOVING_24_HOUR_CHANGE_PERCENTAGE_USD"], stringToDouble)
        
        proposal <- (map["SUPPLY_FUTURE"], stringToDouble)
        
        changePrice <- (map["PRICE_CONVERSION_VALUE"], stringToDouble)
        
        confirmationAlgorithm <- map["ASSET_DESCRIPTION_SNIPPET"]
        hasingAlgorithm <- map["ASSET_TYPE"]
        
        iconURL <- (map["LOGO_URL"], URLTransform())
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.coinId == rhs.coinId
    }
}
