//
//  FavoritesinteractorInput.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

protocol FavoritesInteractorInput: AnyObject {
    
    func subscribeToFavorites()
    
    func removeFavorite(_ coin: Coin)
}

