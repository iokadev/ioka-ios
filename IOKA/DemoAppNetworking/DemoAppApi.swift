//
//  DemoAppApi.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation




class DemoAppApi {
    static let shared = DemoAppApi()
    
    private let endPointRouter = EndPointRouter<DemoAppEndPoint>()
    
    func decodeAnyObject<T: Codable>(data: Data, model: T.Type) -> T? {
            let response = try? JSONDecoder().decode(T.self, from: data)
            return response
    }
    
    
    func createOrder(price: String, completion: @escaping(CreateOrderResponse?) -> Void) {
        endPointRouter.request(.createOrder(price: price)) { data, response, error in
            if let error = error {
                
            }
            
            if let data = data {
                let object = self.decodeAnyObject(data: data, model: CreateOrderResponse.self)
                completion(object)
            }
        }
    }
}

struct CreateOrderResponse: Codable {
    let order_access_token: String
    let customer_access_token: String
}
