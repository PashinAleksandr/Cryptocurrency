
import Swinject

final class MainModuleAssembler {
    
    private static var assembler: Assembler!
    
    public static var resolver: Resolver {
        return MainModuleAssembler.assembler.resolver
    }
    
    private init() {}
    
    static func initialise() {
        MainModuleAssembler.assembler = MainModuleAssembler.assemble()
    }
    
    private static func assemble() -> Assembler {
        let allModules = initPresentationModules() + initServiceModules()
        return Assembler(allModules)
    }
    
}

extension MainModuleAssembler {
    
    private static func initPresentationModules() -> [Assembly] {
        return [
            CryptocurrencyListModuleAssembly(), FavoritesModuleAssembly(), DetailsModuleAssembly(), ServiceAssembly()
        ]
    }
    
    private static func initServiceModules() -> [Assembly] {
        return [
            
        ]
    }
    
}


import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoinProviderProtocol.self) { _ in
            MockCoinProvider()
        }.inObjectScope(.container)
        
        container.register(FavoritesServiceProtocol.self) { r in
            let provider = r.resolve(CoinProviderProtocol.self)!
            return FavoritesService(coinProvider: provider)
        }.inObjectScope(.container)
    }
}


