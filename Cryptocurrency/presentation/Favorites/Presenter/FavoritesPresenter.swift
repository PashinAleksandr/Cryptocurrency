//
//  FavoritesPresenter.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation

class FavoritesPresenter: NSObject, FavoritesModuleInput, FavoritesViewOutput {

    weak var view: FavoritesViewInput!
    var interactor: FavoritesInteractorInput!
    var router: FavoritesRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
}

extension FavoritesPresenter: FavoritesInteractorOutput {
}