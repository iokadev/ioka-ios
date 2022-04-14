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
    
    var errorDescription: String? {
        IokaLocalizable.serverError
    }
}
