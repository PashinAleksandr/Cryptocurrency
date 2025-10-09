//
//  ChartDataService.swift
//  Cryptocurrency
//
//  Created by ChatGPT on 07/10/2025.
//

import Foundation
import RxSwift

protocol ChartDataServiceProtocol {
    func fetchChartPoints(for range: ChartRange,
                          instrument: String,
                          market: String,
                          limit: Int,
                          aggregate: Int) -> Single<[ChartPoint]>
}

final class ChartDataService: ChartDataServiceProtocol {
    private let apiKey = "57282f6c0fa771e4548f532a44dfe99c8ad10bc34e197090a457711a79fc5d3b"
    
    func fetchChartPoints(for range: ChartRange,
                          instrument: String = "BTC-USD",
                          market: String = "kraken",
                          limit: Int = 100,
                          aggregate: Int = 1) -> Single<[ChartPoint]> {
        return Single.create { single in
            var comps = URLComponents()
            comps.scheme = "https"
            comps.host = "data-api.coindesk.com"
            comps.path = "/spot/v1/historical/days"
            comps.queryItems = [
                URLQueryItem(name: "market", value: market),
                URLQueryItem(name: "instrument", value: instrument),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "aggregate", value: String(aggregate)),
                URLQueryItem(name: "fill", value: "true"),
                URLQueryItem(name: "apply_mapping", value: "true"),
                URLQueryItem(name: "response_format", value: "JSON"),
                URLQueryItem(name: "to_ts", value: String(range.toTS)),
                URLQueryItem(name: "groups", value: "ID"),
                URLQueryItem(name: "api_key", value: self.apiKey)
            ]
            
            guard let url = comps.url else {
                single(.failure(NSError(domain: "ChartDataService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let err = error {
                    single(.failure(err))
                    return
                }
                guard let data = data else {
                    single(.failure(NSError(domain: "ChartDataService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                
                do {
                    let raw = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonRoot = raw as? [String: Any]
                    
                    var points: [ChartPoint] = []
                    
                    func parseValuesArray(_ arr: [[String: Any]]) -> [ChartPoint] {
                        var out: [ChartPoint] = []
                        for item in arr {
                            var ts: TimeInterval = 0
                            // ts common keys
                            if let t = item["ts"] as? TimeInterval { ts = t }
                            else if let t = item["ts"] as? Double { ts = t }
                            else if let t = item["ts"] as? Int { ts = Double(t) }
                            else if let t = item["time"] as? TimeInterval { ts = t }
                            else if let t = item["timestamp"] as? TimeInterval { ts = t }
                            else if let s = item["date"] as? String {
                                if let iso = ISO8601DateFormatter().date(from: s) {
                                    ts = iso.timeIntervalSince1970
                                } else {
                                    let df = DateFormatter()
                                    df.dateFormat = "yyyy-MM-dd"
                                    if let d = df.date(from: s) {
                                        ts = d.timeIntervalSince1970
                                    }
                                }
                            }
                            
                            // price candidates
                            let priceKeys = ["close", "price", "close_price", "price_usd", "rate", "y", "value"]
                            var price: Double? = nil
                            for k in priceKeys {
                                if let p = item[k] as? Double { price = p; break }
                                if let p = item[k] as? Int { price = Double(p); break }
                                if let ps = item[k] as? String, let p = Double(ps) { price = p; break }
                            }
                            // fallback: scan for any numeric value
                            if price == nil {
                                for (_, v) in item {
                                    if let d = v as? Double { price = d; break }
                                    if let i = v as? Int { price = Double(i); break }
                                    if let s = v as? String, let d = Double(s) { price = d; break }
                                }
                            }
                            
                            if let p = price {
                                // If ts == 0 use current as fallback (so chart still shows something)
                                let realTs = ts > 0 ? ts : Date().timeIntervalSince1970
                                out.append(ChartPoint(ts: realTs, price: p))
                            }
                        }
                        return out
                    }
                    
                    // 1) common pattern: root["data"] -> ["values": [ {..}, ... ]]
                    if let dataDict = jsonRoot?["data"] as? [String: Any] {
                        if let values = dataDict["values"] as? [[String: Any]], !values.isEmpty {
                            points.append(contentsOf: parseValuesArray(values))
                        } else if let arr = dataDict["list"] as? [[String: Any]], !arr.isEmpty {
                            points.append(contentsOf: parseValuesArray(arr))
                        }
                    }
                    
                    // 2) root["data"] as array
                    if points.isEmpty {
                        if let arr = jsonRoot?["data"] as? [[String: Any]], !arr.isEmpty {
                            points.append(contentsOf: parseValuesArray(arr))
                        }
                    }
                    
                    // 3) root["values"]
                    if points.isEmpty {
                        if let arr = jsonRoot?["values"] as? [[String: Any]], !arr.isEmpty {
                            points.append(contentsOf: parseValuesArray(arr))
                        }
                    }
                    
                    // 4) try to find first array anywhere in root
                    if points.isEmpty, let root = jsonRoot {
                        for (_, v) in root {
                            if let arr = v as? [[String: Any]], !arr.isEmpty {
                                points.append(contentsOf: parseValuesArray(arr))
                                if !points.isEmpty { break }
                            }
                        }
                    }
                    
                    // 5) special case: find dictionary where keys are dates and values are prices
                    if points.isEmpty, let root = jsonRoot {
                        for (_, v) in root {
                            if let dict = v as? [String: Any] {
                                var allDatePricePairs: [(String, Double)] = []
                                for (k, val) in dict {
                                    if let d = val as? Double {
                                        allDatePricePairs.append((k, d))
                                    } else if let s = val as? String, let d = Double(s) {
                                        allDatePricePairs.append((k, d))
                                    }
                                }
                                if !allDatePricePairs.isEmpty {
                                    let dfISO = ISO8601DateFormatter()
                                    let dfShort = DateFormatter()
                                    dfShort.dateFormat = "yyyy-MM-dd"
                                    for (k,v) in allDatePricePairs {
                                        var ts: TimeInterval = 0
                                        if let date = dfISO.date(from: k) {
                                            ts = date.timeIntervalSince1970
                                        } else if let date = dfShort.date(from: k) {
                                            ts = date.timeIntervalSince1970
                                        }
                                        if ts > 0 {
                                            points.append(ChartPoint(ts: ts, price: v))
                                        }
                                    }
                                    if !points.isEmpty { break }
                                }
                            }
                        }
                    }
                    
                    if points.isEmpty {
                        single(.failure(NSError(domain: "ChartDataService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Cannot parse chart points"])))
                        return
                    }
                    
                    // sort by ts ascending
                    points.sort { $0.ts < $1.ts }
                    single(.success(points))
                } catch {
                    single(.failure(error))
                }
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
