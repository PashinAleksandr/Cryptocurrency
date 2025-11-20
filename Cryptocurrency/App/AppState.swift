//
//  AppState.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 19.11.2025.
//

import Foundation
import RxSwift
import RxRelay

class AppState {
    
    var isFetchCoinsInProcess: BehaviorRelay<Bool> = .init(value: false)
    
}
