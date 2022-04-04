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
    
    private func decodeAnyObject<T: Codable>(data: Data, model: T.Type) -> T? {
            let response = try? JSONDecoder().decode(T.self, from: data)
            return response
    }
    
    private func handleRequest<T: Codable>(data: Data?, response: URLResponse?, error: Error?, model: T.Type, completion: @escaping((T?, IokaError?) -> Void)) {
        if let error = error {
            completion(nil, IokaError(code: .networkError, message: error.localizedDescription))
            return
        }
        
        guard let data = data else {
            completion(nil, IokaError(code: .noData, message: "No data from call"))
            return
        }
        
        if let response = response as? HTTPURLResponse {
            guard let result = HTTPResponseStatus(rawValue: response.statusCode) else { return }
        
            switch result.responseType {
            case .success:
                let responseObject = self.decodeAnyObject(data: data, model: T.self)
                completion(responseObject, nil)
            case .failure:
                let responseObject = self.decodeAnyObject(data: data, model: IokaError.self)
                completion(nil, responseObject)
            }
        }
    }
    
    
    func createOrder(price: String, completion: @escaping(CreateOrderResponse?) -> Void) {
        endPointRouter.request(.createOrder(price: price)) { data, response, error in
            if let data = data {
                let object = self.decodeAnyObject(data: data, model: CreateOrderResponse.self)
                completion(object)
            }
        }
    }
    
    func getProfile(completion: @escaping(GetProfileResponse?, IokaError?) -> Void) {
        endPointRouter.request(.getProfile) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: GetProfileResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
}

struct CreateOrderResponse: Codable {
    let order_access_token: String
    let customer_access_token: String
}
