//
//  detailsFactory.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import Swinject

class DetailsFactory: PresentationModuleFactory {
    private let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    func instantiateViewController() -> detailsViewController {
        let vc = MainModuleAssembler.resolver.resolve(detailsViewController.self, argument: coin)!
        return vc
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class detailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(detailsViewController.self) { (resolver: Resolver, coin: Coin) in
            let vc = detailsViewController()
            let router = detailsRouter()
            router.transitionHandler = vc
            
            let presenter = detailsPresenter()
            presenter.view = vc
            presenter.router = router
            
            vc.output = presenter
            
            let interactor = detailsInteractor()
            interactor.favoritesService = resolver.resolve(FavoritesServiceProtocol.self)
            interactor.output = presenter
            presenter.interactor = interactor
            presenter.configure(with: coin)
            
            return vc
        }.inObjectScope(.transient)
    }
}



