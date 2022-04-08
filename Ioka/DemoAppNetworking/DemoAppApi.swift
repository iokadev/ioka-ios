//
//  DemoAppApi.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation


internal struct DemoAppError: Codable {
    var code: String
    var message: String
}



internal class DemoAppApi {
    static let shared = DemoAppApi()
    
    private let endpointRouter = EndpointRouter<DemoAppEndPoint>()
    
    private func decodeAnyObject<T: Codable>(data: Data, model: T.Type) -> T? {
            let response = try? JSONDecoder().decode(T.self, from: data)
            return response
    }
    
    private func handleRequest<T: Codable>(data: Data?, response: URLResponse?, error: Error?, model: T.Type, completion: @escaping((T?, DemoAppError?) -> Void)) {
        if let error = error {
            completion(nil, DemoAppError(code: "sdsd", message: error.localizedDescription))
            return
        }
        
        guard let data = data else {
            completion(nil, DemoAppError(code: "dsds", message: "No data from call"))
            return
        }
        
        if let response = response as? HTTPURLResponse {
            guard let result = HTTPResponseStatus(rawValue: response.statusCode) else { return }
        
            switch result.responseType {
            case .success:
                let responseObject = self.decodeAnyObject(data: data, model: T.self)
                completion(responseObject, nil)
            case .failure:
                let responseObject = self.decodeAnyObject(data: data, model: DemoAppError.self)
                completion(nil, responseObject)
            }
        }
    }
    
    
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
