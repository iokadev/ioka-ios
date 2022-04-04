//
//  PaymentCreationResponseStatus.swift
//  iOKA
//
//  Created by ablai erzhanov on 03.03.2022.
//

import Foundation

/// The response class representation of status codes, these get grouped by their first digit.
enum ResponseType {
    
    /// - success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
    case success
    
    /// - failure:
    case failure
}


enum HTTPResponseStatus: Int {
    
    /// - created:
    case created = 201
    
    /// - ok:
    case ok = 200
    
    case noContent = 204

    //
    // Client Error - 4xx
    //
    
    /// - badRequest: Ошибка валидации данных.
    case badRequest = 400
    
    /// - paymentRequired: The content available on the server requires payment.
    case paymentRequired = 402
    
    /// - AUTH ERROR:
    case authenticationError = 401
    
    /// - forbidden: Доступ запрещен.
    case forbidden = 403
    
    /// - notFound:
    case notFound = 404
    
    ///
    case notAllowed = 405
    
    /// - conflict: Исчерпано количество попыток оплаты. Может возникнуть при попытке повторного создания платежа.
    case conflict = 409
    
    //
    // Server Error - 5xx
    //
    
    /// - В процессе обработки платформой запроса возникла непредвиденная ситуация. При получении подобного кода ответа мы рекомендуем обратиться в техническую поддержку.
    case internalServerError = 500
    
    /// - Платформа временно недоступна и не готова обслуживать данный запрос. Запрос гарантированно не выполнен, при получении подобного кода ответа попробуйте выполнить его позднее, когда доступность платформы будет восстановлена.
    case serviceUnavailable = 503
    
    /// - Платформа превысила допустимое время обработки запроса, результат запроса не определён. Попробуйте отправить запрос повторно или выяснить результат выполнения исходного запроса, если повторное исполнение запроса нежелательно.
    case gatewayTimeout = 504
    
    /// The class (or group) which the status code belongs to.
    var responseType: ResponseType {
        
        switch self.rawValue {
        case 200..<300:
            return .success
        default:
            return .failure
        }
    }
}

