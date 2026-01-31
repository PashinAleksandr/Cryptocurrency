
import Foundation

struct ChartPoint {
    let ts: TimeInterval
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    
    init(ts: TimeInterval, open: Double, high: Double, low: Double, close: Double) {
        self.ts = ts
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
    
    init(item: [String: Any]) throws {
        guard
            let ts = item["TIMESTAMP"] as? TimeInterval,
            let open = item["OPEN"] as? Double,
            let high = item["HIGH"] as? Double,
            let low = item["LOW"] as? Double,
            let close = item["CLOSE"] as? Double
        else {
            throw CoinError.nowData
        }
        self.ts = ts
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
}

