//
//  MainModuleAssembler.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 07.09.2025.
//

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
            CryptocurrencyListModuleAssembly(), FavoritesModuleAssembly(), detailsModuleAssembly()
        ]
    }
    
    private static func initServiceModules() -> [Assembly] {
        return [
        
        ]
    }
    
}

