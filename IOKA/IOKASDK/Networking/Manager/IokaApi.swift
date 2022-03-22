//
//  NetworkManager.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

typealias paymentCreationCompletion = (CardPaymentResponse?, CustomError?) -> Void
typealias getBrandCompletion = (GetBrandResponse?, CustomError?) -> Void
typealias getEmitterByBinCodeCompletion = (GetEmitterByBinCodeResponse?, CustomError?) -> Void
typealias getCardsCompletion = ([GetCardResponse]?, CustomError?) -> Void
typealias createBindingCompletion = (GetCardResponse?, CustomError?) -> Void
typealias deleteCardByIDResponseCompletion = (DeleteCardByIDResponse?, CustomError?) -> Void
typealias getCardByIDCompletion = (GetCardResponse?, CustomError?) -> Void
typealias getPaymentByIDResponseCompletion = (CardPaymentResponse?, CustomError?) -> Void


class IokaApi {
    static let environment: NetworkEnvironment = .stage
    static let shared = IokaApi()
    
    private let endPointRouter = EndPointRouter<IokaApiEndPoint>()
    
    private func decodeAnyObject<T: Codable>(data: Data, model: T.Type) -> T {
            let response = try! JSONDecoder().decode(T.self, from: data)
            return response
    }
    
    private func handleRequest<T: Codable>(data: Data?, response: URLResponse?, error: Error?, model: T.Type, completion: @escaping((T?, CustomError?) -> Void)) {
        if let error = error {
            completion(nil, CustomError(code: .networkError, message: error.localizedDescription))
            return
        }
        
        guard let data = data else {
            completion(nil, CustomError(code: .noData, message: "No data from call"))
            return
        }
        
        if let response = response as? HTTPURLResponse {
            guard let result = HTTPResponseStatus(rawValue: response.statusCode) else { return }
        
            switch result.responseType {
            case .success:
                let responseObject = self.decodeAnyObject(data: data, model: T.self)
                completion(responseObject, nil)
            case .failure:
                let responseObject = self.decodeAnyObject(data: data, model: CustomError.self)
                completion(nil, responseObject)
            }
        }
    }
    
    func createCardPayment(orderId: String, card: Card, completion: @escaping(paymentCreationCompletion)) {
        endPointRouter.request(.createCardPayment(orderId: orderId, card: card)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: CardPaymentResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func getBrand(partialBin: String, completion: @escaping(getBrandCompletion)) {
        endPointRouter.request(.getBrand(partialBin: partialBin)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: GetBrandResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func getEmitterByBinCode(binCode: String, completion: @escaping(getEmitterByBinCodeCompletion)) {
        endPointRouter.request(.getEmitterByBinCode(binCode: binCode)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: GetEmitterByBinCodeResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func getCards(customerId: String, completion: @escaping(getCardsCompletion)) {
        endPointRouter.request(.getCards(customerId: customerId)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: [GetCardResponse].self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func createBinding(customerId: String, card: Card, completion: @escaping(createBindingCompletion)) {
        endPointRouter.request(.createBinding(customerId: customerId, card: card)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: GetCardResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func deleteCard(customerId: String, cardId: String, completion: @escaping(deleteCardByIDResponseCompletion)) {
        endPointRouter.request(.deleteCardByID(customerId: customerId, cardId: cardId)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: DeleteCardByIDResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func getCardByID(customerId: String, cardId: String, completion: @escaping(getCardByIDCompletion)) {
        endPointRouter.request(.getCardByID(customerId: customerId, cardId: cardId)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: GetCardResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
    
    func getPaymentByID(orderId: String, paymentId: String, completion: @escaping(getPaymentByIDResponseCompletion)) {
        endPointRouter.request(.getPaymentByID(orderId: orderId, paymentId: paymentId)) { data, response, error in
            self.handleRequest(data: data, response: response, error: error, model: CardPaymentResponse.self) { result, error in
                completion(result, error)
            }
        }
    }
}
