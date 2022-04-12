//
//  APIKey.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation


internal struct APIKey {
    var key: String
    var isStaging: Bool
    
    init(key: String) {
        self.key = key
        
        if key.contains("test") {
            self.isStaging = true
        } else {
            self.isStaging = false
        }
    }
}
