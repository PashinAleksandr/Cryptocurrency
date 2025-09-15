//
//  detailsFactory.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import Foundation
import Swinject

class detailsFactory: PresentationModuleFactory {

    func instantiateViewController() -> detailsViewController {
        let viewController = MainModuleAssembler.resolver.resolve(detailsViewController.self)!
        return viewController
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class detailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(detailsViewController.self) { (resolver: Resolver) in
            let viewController = detailsViewController()
            let router = detailsRouter()
            router.transitionHandler = viewController

            let presenter = detailsPresenter()
            presenter.view = viewController
            presenter.router = router

            viewController.output = presenter
            viewController.moduleInput = presenter

            let interactor = detailsInteractor()
            presenter.interactor = interactor
            interactor.output = presenter

            return viewController
        }.inObjectScope(.transient)
    }
}
