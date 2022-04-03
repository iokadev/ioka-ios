//
//  IOKAAPI.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

enum AuthenticationKeys {
    static let API_KEY = "X-Public-Key"
    static let ORDER_ACCESS_TOKEN_KEY = "X-Order-Access-Token"
    static let CUSTOMER_ACCESS_TOKEN_KEY = "X-Customer-Access-Token"
}



enum NetworkEnvironment {
    case production
    case stage
}

enum IokaApiEndPoint {
    case getBrand(partialBin: String)
    case getEmitterByBinCode(binCode: String)
    case createCardPayment(orderId: String, card: Card)
    case getPaymentByID(orderId: String, paymentId: String)
    case getCards(customerId: String)
    case createBinding(customerId: String, card: Card)
    case getCardByID(customerId: String, cardId: String)
    case deleteCardByID(customerId: String, cardId: String)
}

extension IokaApiEndPoint: EndPointType {
    
    var environmentBaseURL: String {
        switch IokaApi.environment {
        case .stage: return "https://stage-api.ioka.kz/v2/"
        case .production: return "https://api.ioka.kz/V2/"
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("Please present base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getBrand( _):
            return "brands"
        case .getEmitterByBinCode(let binCode):
            return "bins/\(binCode)"
        case .createCardPayment(let orderId, _):
            return "orders/\(orderId)/payments/card"
        case .getPaymentByID(let orderId, let paymentId):
            return "orders/\(orderId)/payments/\(paymentId)"
        case .getCards(let customerId):
            return "customers/\(customerId)/cards"
        case .createBinding(let customerId, _):
            return "customers/\(customerId)/bindings"
        case .getCardByID(let customerId, let cardId):
            return "customers/\(customerId)/cards/\(cardId)"
        case .deleteCardByID(let customerId, let cardId):
            return "customers/\(customerId)/cards/\(cardId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getBrand( _), .getEmitterByBinCode( _), .getCards( _), .getCardByID( _, _), .getPaymentByID( _, _):
            return .get
        case .createCardPayment( _, _), .createBinding( _, _):
            return .post
        case .deleteCardByID( _, _):
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getBrand(let partialBin):
            return .requestParameters(bodyParameters: nil, urlParameters: ["partial_bin": partialBin])
        case .getEmitterByBinCode( _):
            return .request
        case .createCardPayment( _, let card):
            guard let orderAccessToken = IOKA.shared.orderAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            guard let apiKey = IOKA.shared.publicApiKey else { fatalError("You didn't apiKey") }
            return .requestParametersAndHeaders(bodyParameters: card.dictionary, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey, AuthenticationKeys.ORDER_ACCESS_TOKEN_KEY: orderAccessToken, "Content-Type": "application/json; charset=utf-8"])
        case .getPaymentByID( _,  _):
            guard let orderAccessToken = IOKA.shared.orderAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            guard let apiKey = IOKA.shared.publicApiKey else { fatalError("You didn't apiKey") }
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey, AuthenticationKeys.ORDER_ACCESS_TOKEN_KEY: orderAccessToken])
        case .getCards( _):
            guard let customerAccessToken = IOKA.shared.customerAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            guard let apiKey = IOKA.shared.publicApiKey else { fatalError("You didn't apiKey") }
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey, AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken])
        case .createBinding( _, let card):
            guard let customerAccessToken = IOKA.shared.customerAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            return .requestParametersAndHeaders(bodyParameters: card.dictionary, urlParameters: nil, additionalHeaders: [AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken])
        case .getCardByID( _, _):
            guard let customerAccessToken = IOKA.shared.customerAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken])
        case .deleteCardByID( _, _):
            guard let customerAccessToken = IOKA.shared.customerAccessToken else { fatalError("You didn't provided Tokens(neither Customer or order acess tokens)") }
            guard let apiKey = IOKA.shared.publicApiKey else { fatalError("You didn't provide apiKey") }
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey, AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
