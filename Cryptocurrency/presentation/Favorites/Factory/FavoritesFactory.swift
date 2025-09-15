//
//  FavoritesFactory.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import Swinject

class FavoritesFactory: PresentationModuleFactory {

    func instantiateViewController() -> FavoritesViewController {
        let viewController = MainModuleAssembler.resolver.resolve(FavoritesViewController.self)!
        return viewController
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class FavoritesModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FavoritesViewController.self) { (resolver: Resolver) in
            let viewController = FavoritesViewController()
            let router = FavoritesRouter()
            router.transitionHandler = viewController

            let presenter = FavoritesPresenter()
            presenter.view = viewController
            presenter.router = router

            viewController.output = presenter
            viewController.moduleInput = presenter

            let interactor = FavoritesInteractor()
            presenter.interactor = interactor
            interactor.output = presenter

            return viewController
        }.inObjectScope(.transient)
    }
}
