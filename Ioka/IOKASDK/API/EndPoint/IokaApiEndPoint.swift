//
//  IOKAAPI.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

enum AuthenticationKeys {
    // REVIEW: Лучше camelCase
    static let API_KEY = "X-Public-Key"
    static let ORDER_ACCESS_TOKEN_KEY = "X-Order-Access-Token"
    static let CUSTOMER_ACCESS_TOKEN_KEY = "X-Customer-Access-Token"
}

enum IokaApiEndPointType {
    case getBrand(partialBin: String)
    case getEmitterByBinCode(binCode: String)
    case createCardPayment(orderAccessToken: AccessToken, card: Card)
    case getPaymentByID(orderAccessToken: AccessToken, paymentId: String)
    case getCards(customerAccessToken: AccessToken)
    case createBinding(customerAccessToken: AccessToken, card: Card)
    case getCardByID(customerAccessToken: AccessToken, cardId: String)
    case deleteCardByID(customerAccessToken: AccessToken, cardId: String)
    case getOrderByID(orderAccessToken: AccessToken)
}

enum NetworkEnvironment {
    case production
    case stage
}

// REVIEW: 👍🏻
struct IokaApiEndPoint: EndPointType {
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("Please present base URL") }
        return url
    }
    
    var path: String
    
    var httpMethod: HTTPMethod
    
    var task: HTTPTask
    
    var headers: HTTPHeaders?
    
    typealias EndpointError = APIError
    
    var environmentBaseURL: String
    
    
    init(apiKey: APIKey, endPoint: IokaApiEndPointType) {
        
        if apiKey.isStaging {
            self.environmentBaseURL =  "https://stage-api.ioka.kz/v2/"
        } else {
            self.environmentBaseURL = "https://api.ioka.kz/V2/"
        }
        
        switch endPoint {
        case .getBrand(let partialBin):
            self.path = "brands"
            self.httpMethod = .get
            self.task = .requestParameters(bodyParameters: nil, urlParameters: ["partial_bin": partialBin])
        case .getEmitterByBinCode(let binCode):
            self.path = "bins/\(binCode)"
            self.httpMethod = .get
            self.task = .request
        case .createCardPayment(let orderAccessToken, let card):
            self.path = "orders/\(orderAccessToken.id)/payments/card"
            self.httpMethod = .post
            self.task = .requestParametersAndHeaders(bodyParameters: card.dictionary, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey.key, AuthenticationKeys.ORDER_ACCESS_TOKEN_KEY: orderAccessToken.token, "Content-Type": "application/json; charset=utf-8"])
        case .getPaymentByID(let orderAccessToken, let paymentId):
            self.path = "orders/\(orderAccessToken.id)/payments/\(paymentId)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey.key, AuthenticationKeys.ORDER_ACCESS_TOKEN_KEY: orderAccessToken.token])
        case .getCards(let customerAccessToken):
            self.path = "customers/\(customerAccessToken.id)/cards"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey.key, AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken.token])
        case .createBinding(let customerAccessToken, let card):
            self.path = "customers/\(customerAccessToken.id)/bindings"
            self.httpMethod = .post
            self.task = .requestParametersAndHeaders(bodyParameters: card.dictionary, urlParameters: nil, additionalHeaders: [AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken.token])
            // REVIEW: "Content-Type": "application/json; charset=utf-8" надо? если да, то это должно где-то в одном месте сетится для всех post запросов.
        case .getCardByID(let customerAccessToken, let cardId):
            self.path = "customers/\(customerAccessToken.id)/cards/\(cardId)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken.token])
        case .deleteCardByID(let customerAccessToken, let cardId):
            self.path = "customers/\(customerAccessToken.id)/cards/\(cardId)"
            self.httpMethod = .delete
            self.task = .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey.key, AuthenticationKeys.CUSTOMER_ACCESS_TOKEN_KEY: customerAccessToken.token])
        case .getOrderByID(let orderAccessToken):
            self.path = "orders/\(orderAccessToken.id)"
            self.httpMethod = .get
            // REVIEW: почему где-то есть APIKey, где-то нет? он должен быть везде, и должен сетиться где-то в одном месте
            self.task = .requestParametersAndHeaders(bodyParameters: nil, urlParameters: nil, additionalHeaders: [AuthenticationKeys.API_KEY: apiKey.key, AuthenticationKeys.ORDER_ACCESS_TOKEN_KEY: orderAccessToken.token])
        }
    }
    
}
