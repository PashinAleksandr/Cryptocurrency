//
//  MainTabBarController.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 11.09.2025.
//

import Foundation
import UIKit
import SnapKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = CryptocurrencyListFactory().instantiateViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: homeVC)

        let favoritesVC = FavoritesFactory().instantiateViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "star"), tag: 1)
        let favouriteNavController = UINavigationController(rootViewController: favoritesVC)
        
        viewControllers = [homeNavigationController, favouriteNavController]
    }
}
