
import Foundation
import RxSwift
import Charts

protocol DetailsInteractorInput: AnyObject {
    func addToFavorites(_ coin: Coin)
    func removeFromFavorites(_ coin: Coin)
    func isFavorite(_ coin: Coin) -> Bool
    func observeFavorites() -> Observable<[Coin]>
    
    func fetchChartPoints(for range: RangeInterval,
                          instrument: String,
                          completion: @escaping (Result<[ChartPoint], Error>) -> Void)
}


