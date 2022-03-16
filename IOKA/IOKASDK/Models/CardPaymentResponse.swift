//
//  CardPaymentResponse.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation


struct CardPaymentResponse: Codable {
    
    let id: String //-Идентификатор платежа
    let order_id: String //-Идентификатор родительского заказа
    let status: PaymentStatus //-Статус платежа
    let created_at: String //-Время создания платежа
    let approved_amount: Int //-Авторизованная сумма
    let captured_amount: Int //-Сумма списания
    let refunded_amount: Int //-Сумма возврата
    let processing_fee: Double //-Комиссия процессинга
    var payer: Payer? //-Платежные данные (включают информацию по сохраненной карте или по плательщику)
    var error: PaymentError? //-Детальное описание ошибки платежа. Присутствует если status = DECLINED
    var acquirer: Acquirer? //-Данные банка эквайера
    var action: Action?//-Данные для прохождения 3DSecure на стороне Банка
}

struct PaymentError: Codable {
    var code: String
    var message: String
}

struct Acquirer: Codable {
    let name: String //-Название банка-эквайера, где платеж был обработан
    var reference: String? //-Уникальный идентификатор платежа на стороне банка-эквайера. Присутствует при успешной авторизации
}

struct Action: Codable {
    let url: String //-Ссылка для открытия формы верификации 3DSecure от Банка
}
