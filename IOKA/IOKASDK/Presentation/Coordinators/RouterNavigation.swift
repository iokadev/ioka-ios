//
//  RouterNavigation.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit


class RouterNavigation: NSObject {
    let navigationViewController: UINavigationController
    
    init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        super.init()
    }
}

extension RouterNavigation: RouterCoordinator {
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationViewController.pushViewController(viewController, animated: animated)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        self.navigationViewController.dismiss(animated: animated, completion: completion)
    }
    
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.navigationViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func popViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationViewController.popViewController(animated: animated)
    }
    
    func startFlow(_ viewController: UIViewController) {
        self.navigationViewController.pushViewController(viewController, animated: true)
    }
    
    
    func finishFlow(_ viewController: UIViewController) {
        self.navigationViewController.popToViewController(viewController, animated: true)
    }
}
