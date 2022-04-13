//
//  ProgressViewModelProtocol.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

internal enum ProgressViewModelState {
    case idle
    case progress
    case error
}


internal protocol ProgressViewModelProtocol {
    var state: ProgressViewModelState { get set }
    func getOrder()
}
