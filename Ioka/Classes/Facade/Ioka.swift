//
//  Ioka.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit
import PassKit


/// Класс-фасад Ioka SDK. Реализован как синглтон.
/// Предоставляет методы для инициализации SDK, запуска сценариев оплаты и сохранения карты, и работы с сохраненными картами.
public class Ioka {
    /// Синглтон
    static public let shared = Ioka()
    var setupInput: SetupInput?
    var currentCoordinator: Coordinator?
    var applePayConfiguration: ApplePayConfiguration?
    
    
    /// Метод для инициализии SDK. Необходимо вызвать до того, как обращаться к любым другим методам этого класса.
    ///
    /// - Parameters:
    ///   - apiKey: Публичный API-ключ, полученные при регистрации в качестве клиента Ioka
    ///   - theme: Конфигурирует внешний вид экранов Ioka SDK. По умолчанию - объект Theme.default.
    ///   - locale: Конфигурирует локализацию текстов в Ioka SDK. По умолчанию - .automatic.
    ///   Передавать другое значение нужно в том случае, если язык в вашем приложении выбирается вручную.
    public func setup(apiKey: String, theme: Theme = .default, locale: IokaLocale = .automatic) {
        self.setupInput = SetupInput(apiKey: APIKey(key: apiKey))
        applyTheme(theme)
        updateLocale(locale)
    }

    /// Метод для инициализии SDK. Необходимо вызвать до того, как обращаться к любым другим методам этого класса.
    ///
    /// - Parameters:
    ///   - apiKey: Публичный API-ключ, полученные при регистрации в качестве клиента Ioka
    ///   - theme: Конфигурирует внешний вид экранов Ioka SDK. По умолчанию - объект Theme.default.
    ///   - locale: Конфигурация  для функционала ApplePay.
    ///   - applePayConfiguration: Конфигурирует локализацию текстов в Ioka SDK. По умолчанию - .automatic.
    ///   Передавать другое значение нужно в том случае, если язык в вашем приложении выбирается вручную.
    public func setup(apiKey: String, theme: Theme = .default, locale: IokaLocale = .automatic, applePayConfiguration: ApplePayConfiguration) {
        self.setupInput = SetupInput(apiKey: APIKey(key: apiKey))
        applyTheme(theme)
        updateLocale(locale)
        self.applePayConfiguration = applePayConfiguration
    }
    
    /// Метод для запуска сценария оплаты новой картой. Показывает форму для ввода данных карты.
    /// При необходимости проводит проверку 3DSecure. Отображает результат оплаты пользователю.
    /// - Parameters:
    ///   - sourceViewController: Объект UIViewController для экрана, с которого пользователь запускает оплату.
    ///   Перед открытием формы для ввода данных карты Ioka SDK получает объект Order из Ioka API. Во время этого запроса
    ///   поверх sourceViewController показывается индикатор загрузки и могут отображаться ошибки. Также с него происходит
    ///   переход на экраны Ioka SDK.
    ///   - orderAccessToken: Токен для доступа к заказу, который приложение получает от своего бэкенда.
    ///   - applePay: Конфигурация для показа либо скрытия кнопки оплаты при помощи ApplePay .
    ///   - completion: Замыкание, которое вызывается после того, как пользователь закрывает экран результата оплаты или
    ///   любой экран до него. Принимает значение FlowResult: .succeeded - если оплата прошла успешно, .failed - если карта
    ///   была отклонена, .cancelled - если пользователь закрыл экран оплаты или экран 3DSecure. Выполняется в главном потоке.
    public func startPaymentFlow(sourceViewController: UIViewController, orderAccessToken: String, applePay: ApplePayState, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            var input: PaymentFlowInput
            switch applePay {
            case .disable:
                input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, applePayData: nil)
            case .enable(let applePayData):
                input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, applePayData: applePayData)
            }
            let paymentMethodsFlowFactory = PaymentFlowFactory(input: input, featuresFactory: FeaturesFactory())
            let coordinator = PaymentCoordinator(factory: paymentMethodsFlowFactory, sourceViewController: sourceViewController)
            
            currentCoordinator = coordinator
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
            
            coordinator.start()
        } catch let error {
            completion(.failed(error))
        }
    }
    
    /// Метод для запуска сценария оплаты сохраненной картой. Показывает индикатор загрузки, пока проходит оплата. При
    /// необходимости показывает экран ввода CVV. Также при необходимости проводит проверку 3DSecure. Отображает результат
    /// оплаты пользователю.
    /// - Parameters:
    ///   - sourceViewController: Объект UIViewController для экрана, с которого пользователь запускает оплату. Перед
    ///   проведением оплаты Ioka SDK получает объект Order из Ioka API. Во время этого запроса, а также во время проведения
    ///   оплаты, поверх sourceViewController показывается индикатор загрузки и могут отображаться ошибки. Также с него
    ///   происходит переход на экраны Ioka SDK.
    ///   - orderAccessToken: Токен для доступа к заказу, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, которое вызывается после того, как пользователь закрывает экран результата оплаты или любой
    ///   экран до него. Принимает значение FlowResult: .succeeded - если оплата прошла успешно, .failed - если карта была
    ///   отклонена, .cancelled - если пользователь закрыл экран ввода CVV или экран 3DSecure. Выполняется в главном потоке.
    public func startPaymentWithSavedCardFlow(sourceViewController: UIViewController, orderAccessToken: String, card: SavedCard, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, card: card)
            let paymentWithSavedCardFlowFactory = PaymentWithSavedCardFlowFactory(input: input, featuresFactory: FeaturesFactory())
            let coordinator = PaymentWithSavedCardCoordinator(factory: paymentWithSavedCardFlowFactory, sourceViewController: sourceViewController)
            currentCoordinator = coordinator
            
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
            
            coordinator.start()
        } catch let error {
            completion(.failed(error))
        }
    }
    
    /// Метод для запуска сценария сохранения карты. Показывает форму для ввода данных карты. При необходимости проводит
    /// проверку 3DSecure. Отображает результат сохранения пользователю.
    /// - Parameters:
    ///   - sourceViewController: Объект UIViewController для экрана, с которого пользователь запускает сохранение карты.
    ///   С него происходит переход на экраны Ioka SDK.
    ///   - customerAccessToken: Токен для доступа к пользователю, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, которое вызывается после того, как пользователь закрывает экран сохранения. Принимает
    ///   значение FlowResult: .succeeded - если оплата прошла успешно, .cancelled - если пользователь закрыл экран
    ///   сохранения или экран 3DSecure, .failed в данном случае не приходит, так как при ошибке пользователь всегда
    ///   остаётся на экране сохранения. Выполняется в главном потоке.
    public func startSaveCardFlow(sourceViewController: UIViewController, customerAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        
        do {
            let customerAccesstoken = try AccessToken(token: customerAccessToken)
            let saveCardFlowInput = SaveCardFlowInput(setupInput: setupInput, customerAccesstoken: customerAccesstoken)
            let saveCardFlowFactory = SaveCardFlowFactory(input: saveCardFlowInput, featuresFactory: FeaturesFactory())
            let coordinator = SaveCardCoordinator(factory: saveCardFlowFactory, sourceViewController: sourceViewController)
            currentCoordinator = coordinator
            
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
            
            coordinator.start()
        } catch let error {
            completion(.failed(error))
        }
    }
    
    /// Метод для получения сохраненных карт пользователя
    /// - Parameters:
    ///   - customerAccessToken: Токен для доступа к пользователю, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, в которое передаётся результат запроса сохраненных карт. Выполняется в главном потоке.
    public func getCards(customerAccessToken: String, completion: @escaping(Result<[SavedCard], Error>) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failure(DomainError.invalidTokenFormat))
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        let repository = SavedCardRepository(api: api)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            repository.getSavedCards(customerAccessToken: customerAccessToken, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Метод для удаления сохраненной карты пользователя
    /// - Parameters:
    ///   - customerAccessToken: Токен для доступа к пользователю, который приложение получает от своего бэкенда.
    ///   - cardId: id карты, которую нужно удалить.
    ///   - completion: Замыкание, в которое передаётся результат удаления карты. nil - если карта удалена успешно,
    ///   error - если произошла ошибка. Выполняется в главном потоке.
    public func deleteSavedCard(customerAccessToken: String, cardId: String, completion: @escaping(Error?) -> Void) {
        
        guard let setupInput = setupInput else {
            completion(DomainError.invalidTokenFormat)
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.deleteCard(customerAccessToken: customerAccessToken, cardId: cardId) { result in
                switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    if (error as NSError).code == CFNetworkErrors.cfurlErrorCannotParseResponse.rawValue {
                        // костыль. есть какая-то проблема с сервером с непустым ответом при статусе 204.
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
            }
        } catch let error {
            completion(error)
        }
    }

    public func applePayPaymentRequest(sourceViewController: UIViewController, orderAccessToken: String, applePayData: ApplePayData? = nil, completion: @escaping(Result<FlowResult, Error>) -> Void) {
        guard applePayIsAvailable() else { return }
        guard let applePayConfiguration = applePayConfiguration else { return }

        guard let setupInput = setupInput else {
            completion(.failure(DomainError.invalidTokenFormat))
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        let repository = OrderRepository(api: api)

        do {
            let orderAccessToken = try AccessToken(token: orderAccessToken)
            repository.getOrder(orderAccessToken: orderAccessToken) { result in
                switch result {
                case .success(let order):
                    let request = self.createApplePayRequest(order: order, applePayConfiguration: applePayConfiguration, applePayData: applePayData)
                    let repository = ApplePayRepository(api: api)
                    let applePayPaymentData = ApplePayPaymentData(data: "4ZlLTN/GhrRitlzFbGnDdsuu3a4mTjBZRXptYATIQoCIalK7hJQAHBJcqkfQdnKCUnLAbxg310Vm0obyuguFQIeczzVkH+lo9N2UIHwhDlFlTR+nNslBoobHqfziSRldw4avfmaTmwHWNPRV85C0FbZ5YhaLLtypUBFZeEl/TS9Sx7afFHU91JtR+Yj54cH47+6jRNZ5eiodM+HamT5lIdIaYB7HJ26CZphrU2ZE0Okhj5vSmK9ZySsHKUrylyeQ9oZwEEWIk+89MImo6CL/XM5eFQ4SLqukEBan1v137vLytBCIIPNRGMg2TJ+x1Iq8JYSuqTTQ==Hex5x4g2lAfW3yV5EFAiCq7tPNiaBeefol4Z6G8Bs4urIKoLZpenU/2F+bcKgC5yjEIMxvjNuL3/SNP8PLgbZmtjbesD1LJB7K",
                                                                  header: PaymentDataHeader(ephemeralPublicKey: "MFkwEwYHKoZIzj0CAQYIKoZIzdjnxsbiDQgAExAmksc2dq3vOruObvmTF8C7IlBx8BCfyCArAjaYmkZUMKhWHWPtpC3IMDofKiuzOtVVi2VvuNsfxZaUdllYE7Q==",
                                                                                            publicKeyHash: "Dk6svUSoQoWogdiXM6yN6LqrE+kRgr4V9klAMhoViTM=",
                                                                                            transactionId: "6e6c55ff714e956f2f0bb11fcea9a1c3e536f83b749d7fbb255cc10893816b93"),
                                                                  signature: "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",
                                                                  version: "EC_v1"
                    )
                    let applePayPaymentMethod = ApplePayPaymentMethod(displayName: "Visa 1111",
                                                                      network: "Visa",
                                                                      type: "debit")
                    let transactionID = "6E6C55FF714E956F2F0BB11FCEA9AC10893816B93"
                    let applePayParameters = ApplePayParameters(paymentData: applePayPaymentData, paymentMethod: applePayPaymentMethod, transactionIdentifier: transactionID)
                    let viewModel = ApplePayViewModel(repository: repository, orderAccessToken: orderAccessToken, applePayParameters: applePayParameters)
                    viewModel.createPaymentToken { result in
                        print("DEBUG: Result is \(result)")
                    }
                    let vc = ApplePayViewController(request: request, viewModel: viewModel, sourceViewController: sourceViewController)
                    vc.start()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    /// Переключает локаль для локализации текстов в ioka SDK. Необходимо вызвать, если пользователь переключил язык
    /// в приложении.
    public func updateLocale(_ localeParam: IokaLocale) {
        locale = localeParam
    }

    public func applePayIsAvailable() -> Bool {
        PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: getSupportedNetworks())
    }

    internal func createApplePayRequest(order: Order, applePayConfiguration: ApplePayConfiguration, applePayData: ApplePayData?) -> PKPaymentRequest {

        let paymentSummaryItems = applePayData?.summaryItems ?? [PKPaymentSummaryItem(label: applePayConfiguration.merchantName, amount: NSDecimalNumber(value: order.amount / 100), type: .final)]

        let currencyCode = order.currency
        let supportedNetworks = self.getSupportedNetworks()
        let capability: PKMerchantCapability = .capability3DS

        let request = PKPaymentRequest()
        request.paymentSummaryItems = paymentSummaryItems
        request.currencyCode = currencyCode
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = capability
        request.countryCode = applePayConfiguration.countryCode

        return request
    }
    
    private func applyTheme(_ theme: Theme) {
        colors = theme.colors
        typography = theme.typography
    }

    private func getSupportedNetworks() -> [PKPaymentNetwork] {
        if #available(iOS 14.5, *) {
            return [.discover, .amex, .visa, .masterCard, .mir, .chinaUnionPay]
        } else {
            return [.discover, .amex, .visa, .masterCard, .chinaUnionPay]
        }
    }
}
