//
//  FavoritesService.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 24.09.2025.
//

import RxSwift
import RxRelay
import RxCocoa
import Foundation

class FavoritesService: FavoritesServiceProtocol {
    
    private let storageKey = "favorites.coins"
    internal let favorites = BehaviorRelay<[Coin]>(value: [])
    
    init() {
        loadFromDisk()
    }
    
    func add(_ coin: Coin) {
        var current = favorites.value
        guard !current.contains(coin) else { return }
        current.append(coin)
        favorites.accept(current)
        saveToDisk(current)
    }
    
    func remove(_ coin: Coin) {
        var current = favorites.value
        current.removeAll { $0 == coin }
        favorites.accept(current)
        saveToDisk(current)
    }
    
    func toggle(_ coin: Coin) {
        if isFavorite(coin) {
            remove(coin)
        } else {
            add(coin)
        }
    }
    
    func isFavorite(_ coin: Coin) -> Bool {
        return favorites.value.contains(coin)
    }
    // TODO: сохраняй только id а остальное догружай
    private func saveToDisk(_ coins: [Coin]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(coins) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadFromDisk() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        let decoder = JSONDecoder()
        if let saved = try? decoder.decode([Coin].self, from: data) {
            favorites.accept(saved)
        }
    }
}

