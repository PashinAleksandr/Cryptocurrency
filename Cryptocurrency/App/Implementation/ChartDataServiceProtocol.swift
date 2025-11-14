

import Foundation

protocol ChartDataServiceProtocol: AnyObject {
//    func fetchChartPoints(
//        for range: RangeInterval,
//        instrument: String,
//        market: String,
//        limit: Int,
//        aggregate: Int,
//        date: String,
//        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
//    )
    func fetchChartPoints(
        for range: RangeInterval,
        instrument: String,
        market: String,
        aggregate: Int,
        intervalType: ChartDataService.IntervalType,
        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
    )
}
