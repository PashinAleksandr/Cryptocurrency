
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
            
            let favoritesService = resolver.resolve(FavoritesServiceProtocol.self)!
            let interactor = FavoritesInteractor()
            interactor.favoritesService = favoritesService
            presenter.interactor = interactor
            interactor.output = presenter
            
            return viewController
        }.inObjectScope(.transient)
    }
}

