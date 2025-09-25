//
//  detailsinteractorInput.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import RxSwift

protocol detailsInteractorInput: AnyObject {
    func addToFavorites(_ coin: Coin)
    func removeFromFavorites(_ coin: Coin)
    func isFavorite(_ coin: Coin) -> Bool
    func observeFavorites() -> Observable<[Coin]>
}

