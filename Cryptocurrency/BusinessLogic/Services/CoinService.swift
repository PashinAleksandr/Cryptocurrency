//
//  CoinService.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 29.09.2025.
//

import Foundation
import Alamofire

class CoinService {
    
    func requestToServer() {
        // /asset/v1/top/list?page=1&page_size=100&sort_by=TOTAL_MKT_CAP_USD&sort_direction=DESC&groups=ID,BASIC,SUPPLY,PRICE,MKT_CAP,VOLUME,CHANGE,TOPLIST_RANK&toplist_quote_asset=USD
        let params: Parameters = ["page" : 1, "page_size" : 100, "sort_by" : "TOTAL_MKT_CAP_USD", "sort_direction" :  "DESC", "groups" : "ID,BASIC,SUPPLY,PRICE,MKT_CAP,VOLUME,CHANGE,TOPLIST_RANK", "toplist_quote_asset" : "USD", "api_key" : "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"]
        AF.request("https://data-api.coindesk.com/index/cc/v1/latest/tick", parameters: params).response(completionHandler: { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        })
    }
}

//
//  CoinService.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 29.09.2025.
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

    func fetchCoins() {
        let params: Parameters = ["page" : 1, "page_size" : 100, "sort_by" : "TOTAL_MKT_CAP_USD", "sort_direction" :  "DESC", "groups" : "ID,BASIC,SUPPLY,PRICE,MKT_CAP,VOLUME,CHANGE,TOPLIST_RANK", "toplist_quote_asset" : "USD", "api_key" : "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"]
        let url = "https://api.coincap.io/v2/assets" // пример API
        AF.request("https://data-api.coindesk.com/index/cc/v1/latest/tick", parameters: params).response(completionHandler:{ [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let data = json["data"] as? [[String: Any]] {
                    let mappedCoins = Mapper<Coin>().mapArray(JSONArray: data)
                    self.coins.accept(mappedCoins)
                }
            case .failure(let error):
                print("Ошибка загрузки: \(error.localizedDescription)")
            }
        })
    }
}
