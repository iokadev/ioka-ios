//
//  BankEmiiter.swift
//  iOKA
//
//  Created by ablai erzhanov on 03.03.2022.
//

import Foundation


internal struct GetEmitterByBinCodeResponse: Codable {
    /// - BIN карты.
    let code: String
    
    /// - Платежная система.
    let brand: String
    
    /// - Тип карты (DEBIT, CREDIT).
    var type: String?
    
    /// - Код банка-эмиттера.
    let emitter_code: String
    
    /// - Название банка-эмиттера.
    let emitter_name: String
     
    
}
