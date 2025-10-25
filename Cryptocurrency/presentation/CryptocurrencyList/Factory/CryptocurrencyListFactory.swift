
import Foundation
import Swinject

class CryptocurrencyListFactory: PresentationModuleFactory {
    
    func instantiateViewController() -> CryptocurrencyListViewController {
        return MainModuleAssembler.resolver.resolve(CryptocurrencyListViewController.self)!
    }
    
    func instantiateTransitionHandler() -> TransitionHandlerProtocol {
        return instantiateViewController()
    }
}

class CryptocurrencyListModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CryptocurrencyListViewController.self) { resolver in
            let vc = CryptocurrencyListViewController()
            
            let router = CryptocurrencyListRouter()
            router.transitionHandler = vc
            
            let presenter = CryptocurrencyListPresenter()
            presenter.view = vc
            presenter.router = router
            
            let interactor = CryptocurrencyListInteractor()
            interactor.output = presenter
            interactor.coinsService = resolver.resolve(CoinsServiceProtocol.self)
            
            presenter.interactor = interactor
            vc.output = presenter
            
            return vc
        }.inObjectScope(.transient)
        
        container.register(CoinsServiceProtocol.self) { _ in
            CoinsService()
        }.inObjectScope(.container)
    }
}
