
import UIKit

protocol PresentationModuleFactory {
    func instantiateTransitionHandler() -> TransitionHandlerProtocol
}

protocol TransitionHandlerProtocol: AnyObject {
    
    func presentModule(usingFactory factory: PresentationModuleFactory)
    func showModule(usingFactory factory: PresentationModuleFactory)
    
    func closeModule(_ animated: Bool)
    func show(_ module: TransitionHandlerProtocol)
    func present(module: TransitionHandlerProtocol, animated: Bool)
    func popTo(_ module: TransitionHandlerProtocol, animated: Bool)
    func popTo<T>(_ module: T.Type, animated: Bool)
    func popToRoot(animated: Bool)
}

extension TransitionHandlerProtocol {
    var asViewController: UIViewController? {
        return self as? UIViewController
    }
}

extension UIViewController: TransitionHandlerProtocol {
    func presentModule(usingFactory factory: PresentationModuleFactory) {
        let moduleTransitionHandler = factory.instantiateTransitionHandler()
        present(module: moduleTransitionHandler, animated: true)
    }
    
    func showModule(usingFactory factory: PresentationModuleFactory) {
        let moduleTransitionHandler = factory.instantiateTransitionHandler()
        show(moduleTransitionHandler)
    }
    
    func closeModule(_ animated: Bool) {
        let hasNavigationStack = self.parent is UINavigationController
        
        let navController = self.parent as? UINavigationController
        let count = navigationController?.children.count ?? 0
        
        if hasNavigationStack, count > 1 {
            navController?.popViewController(animated: animated)
        } else if let vc = self.presentingViewController {
            vc.dismiss(animated: animated)
        }
    }
    
    func show(_ module: TransitionHandlerProtocol) {
        guard let vc = module.asViewController else { return }
        self.show(vc, sender: nil)
    }
    
    func present(module: TransitionHandlerProtocol, animated: Bool) {
        guard let vc = module.asViewController else { return }
        self.present(vc, animated: animated)
    }
    
    func popTo(_ module: TransitionHandlerProtocol, animated: Bool) {
        guard let vc = module.asViewController else { return }
        self.navigationController?.popToViewController(vc, animated: animated)
    }
    
    func popTo<T>(_ module: T.Type, animated: Bool) {
        if let vc = self.navigationController?.children.first(where: { $0 is T }) {
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    func popToRoot(animated: Bool) {
        self.asViewController?.navigationController?.popToRootViewController(animated: animated)
    }
    
}

