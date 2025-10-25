
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
    
    func fetchChartPoints(for range: RangeInterval, instrument: String, completion: @escaping (Result<[ChartPoint], Error>) -> Void) {
        chartService.fetchChartPoints(for: range, instrument: instrument, market: "kraken", limit: 100, aggregate: 1) { points, error in
            if let error = error {
                self.output.showError(error: error)
            } else if let points = points {
                completion(.success(points))
            }
        }
    }
}
