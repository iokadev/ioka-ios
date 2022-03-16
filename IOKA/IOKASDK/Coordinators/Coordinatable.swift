//
//  Coordinatable.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation



protocol Coordinatable: NSObject {
    func pushViewController()
    func dismissViewController()
    func presentViewController()
    func popViewController()
}
