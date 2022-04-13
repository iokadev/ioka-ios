//
//  FlowResult.swift
//  Ioka
//
//  Created by ablai erzhanov on 08.04.2022.
//

import Foundation


public enum FlowResult: Equatable {
    case succeeded
    case cancelled
    case failed(Error)
    
    public static func == (lhs: FlowResult, rhs: FlowResult) -> Bool {
        switch (lhs, rhs) {
        case (.succeeded, .succeeded):
            return true
        case (.cancelled, .cancelled):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}
