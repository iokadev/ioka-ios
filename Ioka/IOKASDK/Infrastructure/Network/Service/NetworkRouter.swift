//
//  NetowrkRouter.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request<Response: Decodable>(_ route: EndPoint, completion: @escaping (Result<Response, Error>) -> Void)
    func cancel()
}
