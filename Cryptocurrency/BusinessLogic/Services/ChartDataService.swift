import Alamofire
import Foundation

final class ChartDataService: ChartDataServiceProtocol {
    
    static let shared = ChartDataService()
    
    enum IntervalType {
        case day
        case week
        case month
        case year
        case all
        
        var limit: Int {
            switch self {
            case .day: 300
            case .month: 120
            case .week: 340
            case .year: 800
            case .all: 4000
            }
        }
        
        var url: String {
            switch self {
            case .day: ChartDataService.minutesURL
            case .month: ChartDataService.daysURL
            case .week: ChartDataService.hoursURL
            case .year: ChartDataService.daysURL
            case .all: ChartDataService.daysURL
            }
        }
    }
    
    static let hoursURL = Config.ChartAPI.baseURL + Config.ChartAPI.pathHours
    static let daysURL = Config.ChartAPI.baseURL + Config.ChartAPI.pathDays
    static let minutesURL = Config.ChartAPI.baseURL + Config.ChartAPI.pathMinutes
    
    private let apiKey = Config.ChartAPI.apiKey
    
    func fetchChartPoints(
        for range: RangeInterval,
        instrument: String,
        market: String = "kraken",
        aggregate: Int = 1,
        intervalType: IntervalType,
        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
    ) {
       
        
        let parameters: Parameters = [
            "market": market,
            "instrument": instrument,
            "limit": intervalType.limit,
            "aggregate": aggregate,
            "fill": true,
            "apply_mapping": true,
            "response_format": "JSON",
            "to_ts": range.toTS,
            "api_key": apiKey
        ]
        
        AF.request(intervalType.url, method: .get, parameters: parameters)
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
                        try? ChartPoint(item: item)
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
