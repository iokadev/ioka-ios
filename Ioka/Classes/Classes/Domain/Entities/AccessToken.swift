//
//  AccessToken.swift
//  IOKA
import Foundation

internal struct AccessToken {
    let token: String
    
    let id: String
    
    init(token: String) throws {
        self.token = token
        if let id = token.components(separatedBy: "_secret").first {
            self.id = id
        } else {
            throw DomainError.invalidTokenFormat
        }
    }
}
