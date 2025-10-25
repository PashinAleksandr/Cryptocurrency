import Alamofire
import Foundation

func isDebug() -> Bool {
    var isDebug: Bool!
#if DEBUG
    isDebug = true
#else
    isDebug = false
#endif
    return isDebug
}

class Config {
    enum ChartAPI {
        static let baseURL = "https://data-api.coindesk.com"
        static let path = "/spot/v1/historical/days"
        
        static let apiKey: String = {
            return isDebug() ? "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b" : "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"
        }()
    }
}

protocol ChartDataServiceProtocol: AnyObject {
    func fetchChartPoints(
        for range: RangeInterval,
        instrument: String,
        market: String,
        limit: Int,
        aggregate: Int,
        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
    )
}

final class ChartDataService: ChartDataServiceProtocol {
    
    static let shared = ChartDataService()
    
    private let apiKey = Config.ChartAPI.apiKey
    
    func fetchChartPoints(
        for range: RangeInterval,
        instrument: String,
        market: String = "kraken",
        limit: Int = 100,
        aggregate: Int = 1,
        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
    ) {
        let url = Config.ChartAPI.baseURL + Config.ChartAPI.path
        
        let parameters: Parameters = [
            "market": market,
            "instrument": instrument,
            "limit": limit,
            "aggregate": aggregate,
            "fill": true,
            "apply_mapping": true,
            "response_format": "JSON",
            "to_ts": range.toTS,
            "api_key": apiKey
        ]
        
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .response { response in
                do {
                    guard let data = response.data else {
                        throw ValidationErrors.noData
                    }
                    
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        throw ValidationErrors.cantMap
                    }
                    
                    guard let values = json["Data"] as? [[String: Any]] else {
                        throw ValidationErrors.serverError
                    }
                    
                    let points: [ChartPoint] = values.compactMap { item in
                        guard
                            let ts = item["TIMESTAMP"] as? TimeInterval ??
                                (item["TIMESTAMP"] as? Int).map(Double.init),
                            let open = item["OPEN"] as? Double ??
                                (item["OPEN"] as? String).flatMap(Double.init),
                            let high = item["HIGH"] as? Double ??
                                (item["HIGH"] as? String).flatMap(Double.init),
                            let low = item["LOW"] as? Double ??
                                (item["LOW"] as? String).flatMap(Double.init),
                            let close = item["CLOSE"] as? Double ??
                                (item["CLOSE"] as? String).flatMap(Double.init)
                        else {
                            return nil
                        }
                        
                        return ChartPoint(ts: ts, open: open, high: high, low: low, close: close)
                    }
                    
                    if points.isEmpty {
                        throw ValidationErrors.serverError
                    }
                    completionHandler(points, nil)
                    
                } catch {
                    completionHandler(nil, error)
                }
            }
    }
}
