//
//  detailsinteractorInput.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Updated by ChatGPT on 07/10/2025.
//

import Foundation
import RxSwift
import Charts

protocol detailsInteractorInput: AnyObject {
    func addToFavorites(_ coin: Coin)
    func removeFromFavorites(_ coin: Coin)
    func isFavorite(_ coin: Coin) -> Bool
    func observeFavorites() -> Observable<[Coin]>

    /// Добавлено: получить точки для графика
    func fetchChartData(for range: ChartRange) -> Single<[ChartPoint]>
}

protocol detailsInteractorChartInput: AnyObject {
    func loadChart(for section: DetailsSegmentControl.Section) -> Observable<[ChartDataEntry]>
}
