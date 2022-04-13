//
//  NetworkError.swift
//  IOKA

import Foundation

internal enum NetworkError: LocalizedError {
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
        case .urlError(let error):
            return error.localizedDescription
        default:
            return IokaLocalizable.serverError
        }
    }
}
