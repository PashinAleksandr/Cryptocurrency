//
//  detailsPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import RxSwift

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
            .subscribe(onNext: { [weak self] favorites in
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
}

extension detailsPresenter: detailsInteractorOutput {}
