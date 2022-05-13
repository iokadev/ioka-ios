//
//  IOKAAPI.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

internal enum AuthenticationKeys {
    static let apiKey = "X-Public-Key"
    static let orderAccessToken = "X-Order-Access-Token"
    static let customerAccessToken = "X-Customer-Access-Token"
}

internal enum IokaApiEndpointType {
    case getBrand(partialBin: String)
    case getEmitterByBinCode(binCode: String)
    case createCardPayment(orderAccessToken: AccessToken, card: CardParameters)
    case getPaymentByID(orderAccessToken: AccessToken, paymentId: String)
    case getCards(customerAccessToken: AccessToken)
    case createBinding(customerAccessToken: AccessToken, card: CardParameters)
    case getCardByID(customerAccessToken: AccessToken, cardId: String)
    case deleteCardByID(customerAccessToken: AccessToken, cardId: String)
    case getOrderByID(orderAccessToken: AccessToken)
    case createPaymentToken
}

internal enum NetworkEnvironment {
    case production
    case stage
}

internal struct IokaApiEndpoint: EndpointType {
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
    
    
    init(apiKey: APIKey, endpoint: IokaApiEndpointType) {
        
        if apiKey.isStaging {
            self.environmentBaseURL =  "https://stage-api.ioka.kz/v2/"
        } else {
            self.environmentBaseURL = "https://api.ioka.kz/v2/"
        }
        
        switch endpoint {
        case .getBrand(let partialBin):
            self.path = "brands"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: ["partial_bin": partialBin],
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key])
        case .getEmitterByBinCode(let binCode):
            self.path = "bins/\(binCode)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key])
        case .createCardPayment(let orderAccessToken, let card):
            self.path = "orders/\(orderAccessToken.id)/payments/card"
            self.httpMethod = .post
            self.task = .requestParametersAndHeaders(bodyParameters: card.dictionary,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.orderAccessToken: orderAccessToken.token])
        case .getPaymentByID(let orderAccessToken, let paymentId):
            self.path = "orders/\(orderAccessToken.id)/payments/\(paymentId)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.orderAccessToken: orderAccessToken.token])
        case .getCards(let customerAccessToken):
            self.path = "customers/\(customerAccessToken.id)/cards"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.customerAccessToken: customerAccessToken.token])
        case .createBinding(let customerAccessToken, let card):
            self.path = "customers/\(customerAccessToken.id)/bindings"
            self.httpMethod = .post
            self.task = .requestParametersAndHeaders(bodyParameters: card.dictionary,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.customerAccessToken: customerAccessToken.token])
        case .getCardByID(let customerAccessToken, let cardId):
            self.path = "customers/\(customerAccessToken.id)/cards/\(cardId)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.customerAccessToken: customerAccessToken.token])
        case .deleteCardByID(let customerAccessToken, let cardId):
            self.path = "customers/\(customerAccessToken.id)/cards/\(cardId)"
            self.httpMethod = .delete
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.customerAccessToken: customerAccessToken.token])
        case .getOrderByID(let orderAccessToken):
            self.path = "orders/\(orderAccessToken.id)"
            self.httpMethod = .get
            self.task = .requestParametersAndHeaders(bodyParameters: nil,
                                                     urlParameters: nil,
                                                     additionalHeaders: [AuthenticationKeys.apiKey: apiKey.key,
                                                                         AuthenticationKeys.orderAccessToken: orderAccessToken.token])
        case .createPaymentToken:
            print("Hello")
            self.path = ""
            self.httpMethod = .post
            self.task = .request
        }
    }
}
