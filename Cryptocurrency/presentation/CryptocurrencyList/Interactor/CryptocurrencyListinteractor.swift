//
//  CryptocurrencyListinteractor.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import RxSwift

final class CryptocurrencyListInteractor: CryptocurrencyListInteractorInput {
    weak var output: CryptocurrencyListInteractorOutput!
    var coinsService: CoinsServiceProtocol!
    private let disposeBag = DisposeBag()
    
    func subscribeToCoins() {
        coinsService.coins
            .asObservable()
            .subscribe(onNext: { [weak self] coins in
                self?.output?.didUpdateCoins(coins)
            })
            .disposed(by: disposeBag)
    }
    
    func loadCoins() {
        coinsService.fetchCoins()
    }
}
