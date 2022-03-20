//
//  NetowrkRouter.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation


public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
