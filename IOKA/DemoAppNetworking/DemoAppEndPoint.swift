//
//  DemoAppApi.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation

enum DemoAppEndPoint {
    case createOrder(price: String)
    case getProfile
}

extension DemoAppEndPoint: EndPointType {
    
    var environmentBaseURL: String {
        return "https://ioka-example-mobile-backend.herokuapp.com/"
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("Please present base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .createOrder( _):
            return "checkout"
        case .getProfile:
            return "profile"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createOrder( _):
            return .post
        case .getProfile:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createOrder(let price):
            return .requestParametersAndHeaders(bodyParameters: ["price": price], urlParameters: ["platform": "ios"], additionalHeaders: ["Content-Type": "application/json; charset=utf-8", "API-KEY": "shp_GA9Y41H1EJ_test_public_60e22bb99d75650ad1d3e54064461152cb9a954d43ea4629d6931703d5ef87f8"])
        case .getProfile:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters:["platform": "ios"], additionalHeaders: ["Content-Type": "application/json; charset=utf-8", "API-KEY": "shp_GA9Y41H1EJ_test_public_60e22bb99d75650ad1d3e54064461152cb9a954d43ea4629d6931703d5ef87f8"])
        }
       
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
