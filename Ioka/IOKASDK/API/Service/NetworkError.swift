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
    
    // REVIEW: тоже нужно будет локализовать
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Нет данных от сервера"
        case .decodingError:
            return "Неверный формат данных"
        case .invalidHTTPStatusCode:
            return "Неизвестная ошибка"
        case .parameterNil:
            return "Неизвестная ошибка"
        case .encodingFailed:
            return "Неизвестная ошибка"
        case .missingUrl:
            return "Неизвестная ошибка"
        case .urlError(let error):
            return error.localizedDescription
        case .other(let error):
            return error.localizedDescription
        }
    }
}
