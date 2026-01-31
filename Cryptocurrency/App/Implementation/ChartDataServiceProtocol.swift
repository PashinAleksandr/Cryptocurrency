

import Foundation

protocol ChartDataServiceProtocol: AnyObject {
    func fetchChartPoints(
        instrument: String,
        market: String,
        aggregate: Int,
        intervalType: ChartDataService.IntervalType,
        completionHandler: @escaping ([ChartPoint]?, Error?) -> Void
    )
}
