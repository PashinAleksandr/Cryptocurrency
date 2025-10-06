//
//  CoinsService.swift
//  Cryptocurrency
//

import Foundation
import Alamofire
import RxSwift
import RxRelay
import ObjectMapper

protocol CoinsServiceProtocol {
    var coins: BehaviorRelay<[Coin]> { get }
    func fetchCoins()
}

final class CoinsService: CoinsServiceProtocol {
    let coins = BehaviorRelay<[Coin]>(value: [])
    
    // Use the exact URL you provided (api key included)
    private let url = "https://data-api.coindesk.com/asset/v1/top/list?page=1&page_size=100&sort_by=CIRCULATING_MKT_CAP_USD&sort_direction=DESC&groups=ID,BASIC,SUPPLY,PRICE,MKT_CAP,VOLUME,CHANGE,TOPLIST_RANK&toplist_quote_asset=USD&api_key=57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"
    
    func fetchCoins() {
        AF.request(url).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let value):
                // The real response in your sample: top -> Data -> LIST -> [ { ... }, ... ]
                guard
                    let json = value as? [String: Any],
                    let dataDict = json["Data"] as? [String: Any],
                    let listArray = dataDict["LIST"] as? [[String: Any]]
                else {
                    // Some endpoints may return "Data" as an array directly; try fallback:
                    if let dataArr = (value as? [String: Any])?["Data"] as? [[String: Any]] {
                        let mapped = Mapper<Coin>().mapArray(JSONArray: dataArr)
                        self.coins.accept(mapped)
                        return
                    }
                    print("❌ JSON не в ожидаемом формате: \(value)")
                    return
                }
                
                // map array
                let mappedCoins: [Coin] = Mapper<Coin>().mapArray(JSONArray: listArray)
                print("✅ Получено \(mappedCoins.count) монет")
                self.coins.accept(mappedCoins)
                
            case .failure(let error):
                print("❌ Ошибка загрузки: \(error.localizedDescription)")
            }
        }
    }
}
