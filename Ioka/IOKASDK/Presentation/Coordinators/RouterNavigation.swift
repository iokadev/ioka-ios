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
        DispatchQueue.main.async {
            self.navigationViewController.pushViewController(viewController, animated: animated)
        }
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.navigationViewController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.navigationViewController.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func popViewController(_ viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.navigationViewController.popViewController(animated: animated)
        }
    }
    
    func startFlow(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.navigationViewController.pushViewController(viewController, animated: true)
        }
    }
    
    
    func finishFlow(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.navigationViewController.popToViewController(viewController, animated: true)
        }
    }
}
