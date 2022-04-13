//
//  DemoAppApi.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation


internal class DemoAppApi {
    static let shared = DemoAppApi()
    
    private let endpointRouter = EndpointRouter<DemoAppEndPoint>()
    
    
    func createOrder(price: String, completion: @escaping(Result<CreateOrderResponse, Error>) -> Void) {

        endpointRouter.request(.createOrder(price: price), completion: completion)
    }
    
    func getProfile(completion: @escaping(Result<GetProfileResponse, Error>) -> Void) {
        endpointRouter.request(.getProfile, completion: completion)
    }
}

internal struct CreateOrderResponse: Codable {
    let order_access_token: String
    let customer_access_token: String
}
