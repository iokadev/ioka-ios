//
//  HTTPTask.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation


public typealias HTTPHeaders = [String:String]

public enum AccessTokenTypes {
    case apiKey
    case customerAccessToken
}

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters:  Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters:  Parameters?, additionalHeaders: HTTPHeaders?)
    // MARK:  Расширение для будущего использование например: Download, upload
}


