//
//  GetCardResponse.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import Foundation

internal enum SavedCardStatus: String, Decodable {
    case PENDING = "PENDING"
    case APPROVED = "APPROVED"
    case DECLINED = "DECLINED"
    case REQUIRES_ACTION = "REQUIRES_ACTION"
}


public struct SavedCardDTO: Decodable {
    
    
    
    public let id: String //-Идентификатор платежа
    public let customer_id: String //-Идентификатор родительского заказа
    var status: SavedCardStatus?
    public let created_at: String //-Время создания платежа
    public let pan_masked: String //-Авторизованная сумма
    public let expiry_date: String //-Сумма списания
    public let holder: String? //-Сумма возврата
    public let payment_system: String? //-Комиссия процессинга
    public var emitter: String?
    public var cvc_required: Bool //-Платежные данные (включают информацию по сохраненной карте или по плательщику)
    var error: APIError? //-Детальное описание ошибки платежа. Присутствует если status = DECLINED
    var action: ActionDTO?//-Данные для прохождения 3DSecure на стороне Банка
}
