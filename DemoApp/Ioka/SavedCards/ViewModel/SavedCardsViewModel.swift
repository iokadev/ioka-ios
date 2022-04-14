//
//  SavedCardsViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import Ioka

internal class SavedCardsViewModel {
    func getCards(customerAccessToken: String, completion: @escaping([SavedCardDTO]?) -> Void) {
        Ioka.shared.getCards(customerAccessToken: customerAccessToken) { result in
            completion(try? result.get())
        }
    }
}
