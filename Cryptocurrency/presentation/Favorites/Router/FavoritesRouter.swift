
import Foundation
import UIKit

class FavoritesRouter: FavoritesRouterInput {
    weak var transitionHandler: TransitionHandlerProtocol?
    
    func openCryprocurrenctList() {
        guard let tabBarController = self.transitionHandler?.asViewController?.tabBarController else { return }
        if let navController = tabBarController.viewControllers?.first as? UINavigationController {
                navController.popToRootViewController(animated: false)
        }
        tabBarController.selectedIndex = 0

    }
}

