//
//  Action.swift
//  IOKA

import Foundation

internal struct Action {
    private static let returnUrl = "https://ioka.kz"
    
    let returnUrl = Self.returnUrl
    let url: URL
    
    init(url: String) throws {
        guard let initialUrl = URL(string: url),
              var components = URLComponents(url: initialUrl, resolvingAgainstBaseURL: true) else {
            throw DomainError.invalidActionUrl
        }
        
        let item = URLQueryItem(name: "return_url", value: Self.returnUrl)
        if components.queryItems == nil {
            components.queryItems = [item]
        } else {
            components.queryItems?.append(item)
        }
        
        if let url = components.url {
            self.init(url: url)
        } else {
            throw DomainError.invalidActionUrl
        }
    }
    
    init(url: URL) {
        self.url = url
    }
}
