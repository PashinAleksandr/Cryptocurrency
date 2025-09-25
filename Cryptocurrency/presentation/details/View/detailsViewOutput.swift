//
//  detailsViewOutput.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

protocol detailsViewOutput {
    
    var coin: Coin? { get set }
    
    func viewIsReady()
    func didRemoveFavorite(_ coin: Coin)
    func didAddFavorite(_ coin: Coin)
    func didToggleFavorite()
}
