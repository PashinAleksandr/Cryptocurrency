//
//  detailsinteractor.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Updated by ChatGPT on 07/10/2025.
//

import Foundation
import RxSwift

class detailsInteractor: detailsInteractorInput {

    weak var output: detailsInteractorOutput!
    var favoritesService: FavoritesServiceProtocol!
    var chartService: ChartDataServiceProtocol = ChartDataService()

    func addToFavorites(_ coin: Coin) {
        favoritesService.add(coin)
    }

    func removeFromFavorites(_ coin: Coin) {
        favoritesService.remove(coin)
    }

    func isFavorite(_ coin: Coin) -> Bool {
        favoritesService.isFavorite(coin)
    }

    func observeFavorites() -> Observable<[Coin]> {
        return favoritesService.favorites.asObservable()
    }

    func fetchChartData(for range: ChartRange) -> Single<[ChartPoint]> {
        // Можно передать limit/aggregate/инструмент/маркет при необходимости
        return chartService.fetchChartPoints(for: range, instrument: "BTC-USD", market: "kraken", limit: 200, aggregate: 1)
    }
}
