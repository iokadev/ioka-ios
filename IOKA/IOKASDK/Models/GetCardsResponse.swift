//
//  GetCardsResponse.swift
//  IOKA
//
//  Created by ablai erzhanov on 14.03.2022.
//

import Foundation


struct GetCardsResponse: Codable {
    let cards: [GetCardResponse]
}
