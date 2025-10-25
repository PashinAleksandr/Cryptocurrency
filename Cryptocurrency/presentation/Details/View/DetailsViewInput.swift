
import Foundation
import Charts

protocol DetailsViewInput: UIViewInput {
    func setupInitialState()
    func configure(with coin: Coin)
    func updateFavoriteState(_ isFavorite: Bool)
    func showLoading(_ isLoading: Bool)
    func updateChartData(entries: [Charts.ChartDataEntry], chartStep: Int)
}


