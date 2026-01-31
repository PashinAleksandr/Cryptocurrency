
import Foundation
import RxSwift
import Charts

protocol DetailsInteractorChartInput: AnyObject {
    func loadChart(for section: DetailsSegmentControl.Section) -> Observable<[ChartDataEntry]>
}

class DetailsInteractor: DetailsInteractorInput {
    
    weak var output: DetailsInteractorOutput!
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
    
    func fetchChartPoints(instrument: String, section: DetailsSegmentControl.Section, completion: @escaping (Result<[ChartPoint], Error>) -> Void) {
        
        var intervalType: ChartDataService.IntervalType = .all
        switch section {
        case .all: intervalType = .all
        case .day: intervalType = .day
        case .month: intervalType = .month
        case .week: intervalType = .week
        case .year: intervalType = .year
        }
        
        chartService.fetchChartPoints(instrument: instrument, market: "kraken", aggregate: 1, intervalType: intervalType) { points, error in
            if let error = error {
                completion(.failure(error))
            } else if let points = points {
                completion(.success(points))
            }
        }
    }
}
