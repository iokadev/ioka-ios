//
//  NetowrkRouter.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

internal protocol NetworkRouter: AnyObject {
    associatedtype Endpoint: EndpointType
    func request<Response: Decodable>(_ route: Endpoint, completion: @escaping (Result<Response, Error>) -> Void)
    func cancel()
}
