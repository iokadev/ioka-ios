//
//  FlowResult.swift
//  Ioka
//
//  Created by ablai erzhanov on 08.04.2022.
//

import Foundation


public enum FlowResult {
    case succeeded
    case cancelled
    case failed(Error)
}
