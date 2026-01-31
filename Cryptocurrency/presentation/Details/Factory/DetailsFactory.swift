
import Foundation
import Swinject

class DetailsFactory: PresentationModuleFactory {
    private let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    func instantiateViewController() -> DetailsViewController {
        let vc = MainModuleAssembler.resolver.resolve(DetailsViewController.self, argument: coin)!
        return vc
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class DetailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailsViewController.self) { (resolver: Resolver, coin: Coin) in
            let vc = DetailsViewController()
            let router = DetailsRouter()
            router.transitionHandler = vc
            
            let presenter = DetailsPresenter()
            presenter.view = vc
            presenter.router = router
            
            vc.output = presenter
            
            let interactor = DetailsInteractor()
            interactor.favoritesService = resolver.resolve(FavoritesServiceProtocol.self)
            interactor.output = presenter
            presenter.interactor = interactor
            presenter.configure(with: coin)
            
            return vc
        }.inObjectScope(.transient)
    }
}

