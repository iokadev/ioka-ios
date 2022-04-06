//
//  ProgressViewModelProtocol.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

enum ProgressViewModelState {
    case idle
    case progress
    case error
}


protocol ProgressViewModelProtocol {
    var state: ProgressViewModelState { get set }
    func getOrder()
}
