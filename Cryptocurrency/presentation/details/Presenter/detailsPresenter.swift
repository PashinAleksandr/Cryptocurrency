//
//  detailsPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Updated by ChatGPT on 07/10/2025.
//

import Foundation
import RxSwift
import Charts

class detailsPresenter: NSObject, detailsModuleInput, detailsViewOutput {

    weak var view: detailsViewInput!
    var interactor: detailsInteractorInput!
    var router: detailsRouterInput!
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

    // MARK: - load chart
    func loadChart(for section: DetailsSegmentControl.Section) {
        let range: ChartRange
        switch section {
        case .day: range = .day
        case .week: range = .week
        case .month: range = .month
        case .year: range = .year
        case .all: range = .all
        }

        view.showLoading(true)
        interactor.fetchChartData(for: range)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] (points: [ChartPoint]) in
                    guard let self = self else { return }
                    self.view.showLoading(false)

                    // Преобразуем точки в ChartDataEntry.
                    // Здесь x - индекс (0..N-1). При необходимости можно подставить time as x.
                    let entries: [ChartDataEntry] = points.enumerated().map { index, pt in
                        ChartDataEntry(x: Double(index), y: pt.price)
                    }
                    view.updateChartData(entries: entries)
                },
                onFailure: { [weak self] (error: Error) in
                    self?.view.showLoading(false)
                    self?.view.show(error)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension detailsPresenter: detailsInteractorOutput {}
