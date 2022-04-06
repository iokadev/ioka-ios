//
//  GetCardResponse.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import Foundation

enum SavedCardStatus: String, Decodable {
    case PENDING = "PENDING"
    case APPROVED = "APPROVED"
    case DECLINED = "DECLINED"
    case REQUIRES_ACTION = "REQUIRES_ACTION"
}


struct GetCardResponse: Decodable {
    
    let id: String //-Идентификатор платежа
    let customer_id: String //-Идентификатор родительского заказа
    var status: SavedCardStatus?
    let created_at: String //-Время создания платежа
    let pan_masked: String //-Авторизованная сумма
    let expiry_date: String //-Сумма списания
    let holder: String? //-Сумма возврата
    let payment_system: String? //-Комиссия процессинга
    var emitter: String?
    var cvc_required: Bool //-Платежные данные (включают информацию по сохраненной карте или по плательщику)
    var error: APIError? //-Детальное описание ошибки платежа. Присутствует если status = DECLINED
    var action: ActionDTO?//-Данные для прохождения 3DSecure на стороне Банка
}
