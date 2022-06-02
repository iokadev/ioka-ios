//
//  EndPointRoter.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation


internal class EndpointRouter<Endpoint: EndpointType>: NetworkRouter {
    // не нужна очередь запросов? 
    private var task: URLSessionTask?
    
    func request<Response: Decodable>(_ route: Endpoint, completion: @escaping (Result<Response, Error>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                let result: Result<Response, Error> = self.mapResponse(data: data, response: response, error: error)
                
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        } catch {
            completion(.failure(NetworkError.encodingFailed))
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = route.httpMethod.rawValue
        
        if route.httpMethod == .post {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch  {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let additionalHeaders = additionalHeaders else { return }
        
        for (key, value) in additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func mapResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error> {
        switch (data, error) {
        case (.none, .none):
            return .failure(NetworkError.noData)
        case (_, .some(let error)):
            return .failure(error)
        case (.some(let data), .none):
            // мы не можем быть уверены, что с сервера всегда будут приходить только те статусы, которые перечислены в енаме HTTPResponseStatus.
            // guard let result = HTTPResponseStatus(rawValue: response.statusCode) else { return }
            
            let statusIsValid = (200..<300).contains((response as? HTTPURLResponse)?.statusCode ?? 0)
            
            if statusIsValid {
                do {
                    return .success(try JSONDecoder().decode(T.self, from: data))
                } catch {
                    return .failure(NetworkError.decodingError)
                }
            } else {
                do {
                    return .failure(try JSONDecoder().decode(Endpoint.EndpointError.self, from: data))
                } catch {
                    return .failure(NetworkError.invalidHTTPStatusCode)
                }
            }
        }
    }
}
