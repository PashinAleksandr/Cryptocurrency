import Foundation

protocol detailsViewOutput: AnyObject {
    var coin: Coin? { get set }
    
    func viewIsReady()
    func didRemoveFavorite(_ coin: Coin)
    func didAddFavorite(_ coin: Coin)
    func didToggleFavorite()
    func loadChart(for section: DetailsSegmentControl.Section)
}
