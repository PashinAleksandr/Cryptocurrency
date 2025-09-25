//
//  FavoritesViewInput.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol FavoritesViewInput: UIViewInput {
    
    func setupInitialState()
    func showFavorites(_ coins: [Coin])
}

