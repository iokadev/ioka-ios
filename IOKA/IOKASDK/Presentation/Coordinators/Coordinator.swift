//
//  Coordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit


protocol Coordinator: NSObject {
    var navigationViewController: UINavigationController { get }
    var childrenViewControllers: [UIViewController] { get }
    func startFlow()
    func finishFlow(coordinator: Coordinator)
}
