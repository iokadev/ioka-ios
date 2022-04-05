//
//  DemoAppApi.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation



// Здесь можно просто подключить alamofire. Networking SDK не будет публичным.
class DemoAppApi {
    static let shared = DemoAppApi()
    
    private let endPointRouter = EndPointRouter<DemoAppEndPoint>()
    
    private func decodeAnyObject<T: Decodable>(data: Data, model: T.Type) -> T? {
            let response = try? JSONDecoder().decode(T.self, from: data)
            return response
    }
    
    private func handleRequest<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, model: T.Type, completion: @escaping((T?, IokaError?) -> Void)) {
        if let error = error {
            completion(nil, NetworkError.other(error))
            return
        }
        
        guard let data = data else {
            completion(nil, NetworkError.noData)
            return
        }
        
        if let response = response as? HTTPURLResponse {
            guard let result = HTTPResponseStatus(rawValue: response.statusCode) else { return }
        
            switch result.responseType {
            case .success:
                let responseObject = self.decodeAnyObject(data: data, model: T.self)
                completion(responseObject, nil)
            case .failure:
                let responseObject = self.decodeAnyObject(data: data, model: APIError.self)
                completion(nil, responseObject)
            }
        }
    }
    
    
    func createOrder(price: String, completion: @escaping(CreateOrderResponse?) -> Void) {
        endPointRouter.request(.createOrder(price: price)) { (result: Result<CreateOrderResponse, Error>) in
            completion(try? result.get())
        }
    }
    
    func getProfile(completion: @escaping(GetProfileResponse?, IokaError?) -> Void) {
        endPointRouter.request(.getProfile) { (result: Result<GetProfileResponse, Error>) in
            let error: Error? = {
                if case let .failure(error) = result { return error } else { return nil }
            }()
            
            completion(try? result.get(), error)
        }
    }
}

struct CreateOrderResponse: Codable {
    let order_access_token: String
    let customer_access_token: String
}
