//
//  MainTabBarController.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit

internal class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = colors.quaternaryBackground

        viewControllers = [
            createNavigationControllers(for: CartViewController(), title: "Корзина", image: DemoImages.bin),
            createNavigationControllers(for: ProfileViewController(), title: "Профиль", image: DemoImages.profile)
        ]
    }
    
    fileprivate func createNavigationControllers(for rootViewController: UIViewController, title: String, image: UIImage? = nil) -> UIViewController{
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        if let image = image {
            navController.tabBarItem.image = image
        }
        return navController
    }

}
