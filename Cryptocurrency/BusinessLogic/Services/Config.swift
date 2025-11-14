
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
    class ChartAPI {
        static let baseURL = "https://data-api.coindesk.com"
        static let pathDays = "/spot/v1/historical/days"
        static let pathHours = "/spot/v1/historical/hours"
        static let pathMinutes = "/spot/v1/historical/minutes"
        static let coinUrl = "https://data-api.coindesk.com/asset/v1/top/list?page=1&page_size=100&sort_by=CIRCULATING_MKT_CAP_USD&sort_direction=DESC&groups=ID,BASIC,SUPPLY,PRICE,MKT_CAP,VOLUME,CHANGE,TOPLIST_RANK&toplist_quote_asset=USD&api_key=57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"
        
        
        static let apiKey: String = {
            return isDebug() ? "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b" : "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"
        }()
    }
}
