//
//  ParameterEncoding.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

public typealias Parameters = [String:Any]


public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parameterNil = "Parameters in nil bro"
    case encodingFailed = "Parameter encoding failed"
    case missingUrl = "URL is nil"
}
