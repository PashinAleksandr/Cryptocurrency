//
//  CryptocurrencyListFactory.swift
//  Cryptocurrency
//
//  Created by APashin on 09/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import Swinject

class CryptocurrencyListFactory: PresentationModuleFactory {
    
    func instantiateViewController() -> CryptocurrencyListViewController {
        let viewController = MainModuleAssembler.resolver.resolve(CryptocurrencyListViewController.self)!
        return viewController
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class CryptocurrencyListModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CryptocurrencyListViewController.self) { (resolver: Resolver) in
            let viewController = CryptocurrencyListViewController()
            let router = CryptocurrencyListRouter()
            router.transitionHandler = viewController
            
            let presenter = CryptocurrencyListPresenter()
            presenter.view = viewController
            presenter.router = router
            
            viewController.output = presenter
            
            let interactor = CryptocurrencyListInteractor()
            presenter.interactor = interactor
            interactor.output = presenter
            
            return viewController
        }.inObjectScope(.transient)
    }
}
