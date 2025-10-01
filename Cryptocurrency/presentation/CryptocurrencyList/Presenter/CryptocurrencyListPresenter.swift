//
//  CryptocurrencyListPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation


final class CryptocurrencyListPresenter: CryptocurrencyListViewOutput, CryptocurrencyListInteractorOutput {
    
    weak var view: CryptocurrencyListViewInput?
    var interactor: CryptocurrencyListInteractorInput!
    var router: CryptocurrencyListRouterInput!
    
    func viewIsReady() {
        view?.setupInitialState()
        interactor.loadCoins()
    }
    
    func didSelectCoin(_ coin: Coin) {
        router.openDetails(for: coin)
    }
    
    func didLoadCoins(_ coins: [Coin]) {
        view?.showCoins(coins)
    }
}
