//
//  FavoritesViewOutput.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

protocol FavoritesViewOutput {
    
    func didselectCoinListVC()
    func viewIsReady()
    func didRemoveFavorite(_ coin: Coin)
}
