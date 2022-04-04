//
//  RouterCoordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation
import UIKit


protocol RouterCoordinator: NSObject {
    var navigationViewController: UINavigationController { get }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    
    func dismissViewController(animated: Bool, completion: (()-> Void)?)
    
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion: (()-> Void)?)
    
    func popViewController(_ viewController: UIViewController, animated: Bool)
    
    func startFlow(_ viewController: UIViewController)
    
    func finishFlow(_ viewController: UIViewController)
}

protocol PaymentResultNavigationDelegate: NSObject {
    func closePaymentResultViewController()
    func retryPaymentProcess()
}
