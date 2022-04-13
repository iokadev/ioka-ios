//
//  EndPointType.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation


internal protocol EndpointType {
    associatedtype EndpointError: Error, Decodable
    
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
