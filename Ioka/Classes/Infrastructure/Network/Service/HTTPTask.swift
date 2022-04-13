//
//  HTTPTask.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation


internal typealias HTTPHeaders = [String:String]

internal enum AccessTokenTypes {
    case apiKey
    case customerAccessToken
}

internal enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters:  Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters:  Parameters?, additionalHeaders: HTTPHeaders?)
}


