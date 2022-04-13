//
//  APIError.swift
//  IokaDemoApp
//
//  Created by Тимур Табынбаев on 13.04.2022.
//

import Foundation

internal struct APIError: LocalizedError, Decodable {
    let code: String
    let message: String
    
    var errorDescription: String? {
        message
    }
}
