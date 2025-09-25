//
//  FavoritesPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

class FavoritesPresenter: NSObject, FavoritesModuleInput, FavoritesViewOutput {
    
    
    
    weak var view: FavoritesViewInput!
    var interactor: FavoritesInteractorInput!
    var router: FavoritesRouterInput!
    
    func didUpdateFavorites(coins: [Coin]) {
        view.showFavorites(coins)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.subscribeToFavorites()
    }
    
    func didselectCoinListVC() {
        router.openCryprocurrenctList()
    }
    
    func didRemoveFavorite(_ coin: Coin) {
        interactor.removeFavorite(coin)
    }
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    
}

