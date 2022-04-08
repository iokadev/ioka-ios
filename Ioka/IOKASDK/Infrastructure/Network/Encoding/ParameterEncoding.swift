//
//  ParameterEncoding.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

internal typealias Parameters = [String:Any]


internal protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
