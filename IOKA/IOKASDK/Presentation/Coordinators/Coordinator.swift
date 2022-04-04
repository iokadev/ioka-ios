//
//  Coordinator.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit


protocol Coordinator: NSObject {
    var children: [Coordinator] { get }
    var navigationViewController: UINavigationController { get }
    var childrenViewControllers: [UIViewController] { get }
    func startFlow(coordinator: Coordinator)
    func finishFlow(coordinator: Coordinator)
}
