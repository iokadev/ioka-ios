//
//  SavedCardDTO+ToSavedCard.swift
//  Ioka
//
//  Created by Тимур Табынбаев on 14.04.2022.
//

import Foundation

extension SavedCardDTO {
    func toSavedCard() -> SavedCard {
        SavedCard(id: id,
                  maskedPAN: pan_masked,
                  expirationDate: expiry_date,
                  paymentSystem: payment_system,
                  emitter: emitter,
                  cvvIsRequired: cvc_required)
    }
}
