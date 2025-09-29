//
//  CryptocurrencyListPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

class CryptocurrencyListPresenter: NSObject, CryptocurrencyListModuleInput, CryptocurrencyListViewOutput {
    
    
    
    weak var view: CryptocurrencyListViewInput!
    var interactor: CryptocurrencyListInteractorInput!
    var router: CryptocurrencyListRouterInput!
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func didselect(coin: Coin) {
        router.openDetails(coin: coin)
    }
}

extension CryptocurrencyListPresenter: CryptocurrencyListInteractorOutput {
    func didFetchCryptos(coins: [Coin]) {
        
    }
    
}
