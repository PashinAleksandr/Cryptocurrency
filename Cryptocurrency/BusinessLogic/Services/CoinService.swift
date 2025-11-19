

import Foundation
import Alamofire
import RxSwift
import RxRelay
import ObjectMapper

protocol CoinsServiceProtocol {
    var coins: BehaviorRelay<[Coin]> { get }
    func fetchCoins() -> Single<[Coin]>
    func fetchCoins2(complitionHandler: @escaping ([Coin]?, Error?) -> Void)
}

final class CoinsService: CoinsServiceProtocol {
    
    let coins = BehaviorRelay<[Coin]>(value: [])
   
    func fetchCoins() -> Single<[Coin]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "CoinsService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            
            let request = AF.request(Config.ChartAPI.coinUrl).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard
                        let json = value as? [String: Any],
                        let dataDict = json["Data"] as? [String: Any],
                        let listArray = dataDict["LIST"] as? [[String: Any]]
                    else {
                        single(.failure(NSError(domain: "CoinsService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                        return
                    }
                    
                    let newCoinsRaw: [Coin] = Mapper<Coin>().mapArray(JSONArray: listArray)
                    let oldCoins = self.coins.value
                    
                    let updatedCoins: [Coin] = newCoinsRaw.map { newCoin in
                        if let existing = oldCoins.first(where: { $0.coinId == newCoin.coinId }) {
                            existing.priceRelay.accept(newCoin.priceRelay.value)
                            existing.capitalization = newCoin.capitalization
                            existing.changeForDay = newCoin.changeForDay
                            existing.iconURL = newCoin.iconURL
                            return existing
                        } else {
                            return newCoin
                        }
                    }
                    
                    self.coins.accept(updatedCoins)
                    single(.success(updatedCoins))
                    
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create { request.cancel() }
        }
    }

    func fetchCoins2(complitionHandler: @escaping ([Coin]?, Error?) -> Void) {
        let _ = AF.request(Config.ChartAPI.coinUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard
                    let json = value as? [String: Any],
                    let dataDict = json["Data"] as? [String: Any],
                    let listArray = dataDict["LIST"] as? [[String: Any]]
                else {
                    complitionHandler(nil, NSError(domain: "CoinsService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"]))
                    return
                }
                
                let newCoinsRaw: [Coin] = Mapper<Coin>().mapArray(JSONArray: listArray)
                let oldCoins = self.coins.value
                
                let updatedCoins: [Coin] = newCoinsRaw.map { newCoin in
                    if let existing = oldCoins.first(where: { $0.coinId == newCoin.coinId }) {
                        existing.oldPrice = existing.priceRelay.value
                        existing.priceRelay.accept(newCoin.priceRelay.value + Double(Int.random(in: 10...20)))
                        existing.capitalization = newCoin.capitalization
                        existing.changeForDay = newCoin.changeForDay
                        existing.iconURL = newCoin.iconURL
                        return existing
                    } else {
                        return newCoin
                    }
                }
                
                self.coins.accept(updatedCoins)
                complitionHandler(updatedCoins, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
}
