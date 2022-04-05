//
//  NetworkError.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 04.04.2022.
//

import Foundation

enum NetworkError: LocalizedError {
    case noData
    case decodingError
    case invalidHTTPStatusCode
    case parameterNil
    case encodingFailed
    case missingUrl
    case urlError(URLError)
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return ""
        case .decodingError:
            return ""
        case .invalidHTTPStatusCode:
            return ""
        case .parameterNil:
            return ""
        case .encodingFailed:
            return ""
        case .missingUrl:
            return ""
        case .urlError(let error):
            return error.localizedDescription
        case .other(let error):
            return error.localizedDescription
        }
    }
}
