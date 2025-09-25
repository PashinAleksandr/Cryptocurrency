//
//  detailsinteractor.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import RxSwift

class detailsInteractor: detailsInteractorInput {
    
    weak var output: detailsInteractorOutput!
    var favoritesService: FavoritesServiceProtocol!
    
    func addToFavorites(_ coin: Coin) {
        favoritesService.add(coin)
    }
    
    func removeFromFavorites(_ coin: Coin) {
        favoritesService.remove(coin)
    }
    
    func isFavorite(_ coin: Coin) -> Bool {
        favoritesService.isFavorite(coin)
    }
    
    func observeFavorites() -> Observable<[Coin]> {
        return favoritesService.favorites.asObservable()
    }
}

