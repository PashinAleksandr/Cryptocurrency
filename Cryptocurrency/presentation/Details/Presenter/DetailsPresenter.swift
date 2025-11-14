
import Foundation
import RxSwift
import Charts

class DetailsPresenter: NSObject, DetailsModuleInput, DetailsViewOutput {
    
    weak var view: DetailsViewInput!
    var interactor: DetailsInteractorInput!
    var router: DetailsRouterInput!
    var coin: Coin?
    
    private let disposeBag = DisposeBag()
    
    func configure(with coin: Coin) {
        self.coin = coin
    }
    
    func viewIsReady() {
        view.setupInitialState()
        guard let coin = coin else { return }
        
        view.configure(with: coin)
        view.updateFavoriteState(interactor.isFavorite(coin))
        
        interactor.observeFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (favorites: [Coin]) in
                guard let self = self, let coin = self.coin else { return }
                let isFav = favorites.contains(where: { $0.coinId == coin.coinId })
                self.view.updateFavoriteState(isFav)
            })
            .disposed(by: disposeBag)
    }
    
    func didAddFavorite(_ coin: Coin) {
        interactor.addToFavorites(coin)
    }
    
    func didRemoveFavorite(_ coin: Coin) {
        interactor.removeFromFavorites(coin)
    }
    
    func didToggleFavorite() {
        guard let coin = coin else { return }
        if interactor.isFavorite(coin) {
            interactor.removeFromFavorites(coin)
            view.updateFavoriteState(false)
        } else {
            interactor.addToFavorites(coin)
            view.updateFavoriteState(true)
        }
    }
    
    func loadChart(for section: DetailsSegmentControl.Section) {
        let range: RangeInterval
        switch section {
        case .day: range = .day
        case .week: range = .week
        case .month: range = .month
        case .year: range = .year
        case .all: range = .all
        }
        
        view.showLoading(true)
        if let coin = coin {
            interactor.fetchChartPoints(for: range, instrument: (coin.shortCoinName)+"-USD", section: section ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let points):
                    
                    let entries: [CandleChartDataEntry] = points.sorted { $0.ts < $1.ts }.map { pt in
                        CandleChartDataEntry(
                            x: pt.ts,
                            shadowH: pt.high,
                            shadowL: pt.low,
                            open: pt.open,
                            close: pt.close,
                            data: pt.ts as AnyObject
                        )
                    }
                    self.view.updateChartData(entries: entries, chartStep: 0)
                    
                case .failure(let error):
                    self.view.show(error)
                }
                
            }
            
        } else {
            showError(error: "Error" as! Error)
        }
        self.view.showLoading(false)
    }
}


extension DetailsPresenter: DetailsInteractorOutput {
    func showError(error: Error) {
        view.showAllert(title: "Error", message: error.localizedDescription)
    }
}
