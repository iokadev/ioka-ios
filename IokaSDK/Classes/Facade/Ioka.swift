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
    /// Параметр используется для определения показа результата платежа
    public var showResultScreen: Bool = true
    var setupInput: SetupInput?
    var currentCoordinator: Coordinator?
    var applePayConfiguration: ApplePayConfiguration?

    private init() {}

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
    ///   - locale: Конфигурирует локализацию текстов в Ioka SDK. По умолчанию - .automatic.
    ///  Передавать другое значение нужно в том случае, если язык в вашем приложении выбирается вручную.
    ///   - applePayConfiguration: Конфигурация  для функционала ApplePay.

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
    public func startPaymentFlow(sourceViewController: UIViewController, orderAccessToken: String, applePayState: ApplePayState = .disable, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, applePayState: applePayState, showResultScreen: showResultScreen)
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
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, card: card, showResultScreen: showResultScreen)
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

    /// Метод для запуска сценария оплатой ApplePay.. При необходимости проводит
    /// проверку 3DSecure. Отображает результат сохранения пользователю.
    /// - Parameters:
    ///   - sourceViewController: Объект UIViewController для экрана, с которого пользователь запускает сохранение карты.
    ///   С него происходит переход на экраны Ioka SDK.
    ///   - orderAccessToken: Токен для доступа к заказу, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, которое вызывается после того, как пользователь закрывает экран сохранения. Принимает
    ///   значение FlowResult: .succeeded - если оплата прошла успешно, .cancelled - если пользователь закрыл экран
    ///   сохранения или экран 3DSecure, .failed в данном случае не приходит, так как при ошибке пользователь всегда
    ///   остаётся на экране сохранения. Выполняется в главном потоке.
    public func startApplePayFlow(sourceViewController: UIViewController, orderAccessToken: String, applePayData: ApplePayData? = nil, completion: @escaping(FlowResult) -> Void) {
        let applePayService = ApplePayService()
        guard applePayService.applePayIsAvailable() else { return }
        guard let applePayConfiguration = applePayConfiguration else { return }
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }

        let api = IokaApi(apiKey: setupInput.apiKey)
        let repository = OrderRepository(api: api)

        do {
            let token = try AccessToken(token: orderAccessToken)

            repository.getOrder(orderAccessToken: token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let order):
                    let request = applePayService.createApplePayRequest(order: order, applePayConfiguration: applePayConfiguration, applePayData: applePayData)
                    let viewModel = ApplePayViewModel(repository: ApplePayRepository(api: api), orderAccessToken: token)
                    ApplePayViewController.getApplePay(request: request, viewModel: viewModel, sourceViewController: sourceViewController) { applePayTokenResult in
                        self.showApplePayResult(result: applePayTokenResult, orderAccessToken: token, setupInput: setupInput, sourceViewController: sourceViewController, order: order, completion: completion)
                    }
                case .failure(let error):
                    completion(.failed(error))
                }
            }
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

    /// Метод для получения сохраненной карты пользователя по card_id
    /// - Parameters:
    ///   - customerAccessToken: Токен для доступа к пользователю, который приложение получает от своего бэкенда.
    ///   - cardId: id карты, которую нужно  получить.
    ///   - completion: Замыкание, в которое передаётся результат получения карты. savedCard - если карта получена успешно,
    ///   error - если произошла ошибка. Выполняется в главном потоке.
    public func getSavedCardById(customerAccessToken: String, cardId: String, completion: @escaping(Result<SavedCard, Error>) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failure(DomainError.invalidTokenFormat))
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        let repository = SavedCardRepository(api: api)

        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            repository.getSavedCardById(customerAccessToken: customerAccessToken, cardId: cardId, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }

    /// Метод для создания экземпляра SavedCard
    /// - Parameters:
    ///   - id: id сохраненной карты. Используется для удаления карты и для оплаты.
    ///   - maskedPan: Маскированный PAN карты в формате "555555******5599".
    ///   - expirationDate: Срок действия карты в формате "12/24".
    ///   - paymentSystem: Опциональный параметр, указывается платежная система карты.
    ///   - emitter: Опциональный параметр, банк эммитет выпустивший карту.
    ///   - cvvRequired: Требования 3D-secure.
    public func createSavedCardInstance(id: String, maskedPan: String, expirationDate: String?, paymentSystem: String?, emitter: String?, cvvRequired: Bool) -> SavedCard {
        SavedCard(id: id, maskedPAN: maskedPan, expirationDate: expirationDate, paymentSystem: paymentSystem, emitter: emitter, cvvIsRequired: cvvRequired)
    }
    
    /// Переключает локаль для локализации текстов в ioka SDK. Необходимо вызвать, если пользователь переключил язык
    /// в приложении.
    public func updateLocale(_ localeParam: IokaLocale) {
        locale = localeParam
    }
    
    private func applyTheme(_ theme: Theme) {
        colors = theme.colors
        typography = theme.typography
    }

    func startApplePayFlowFromSDK(sourceViewController: UIViewController, orderAccessToken: AccessToken, order: Order, applePayData: ApplePayData? = nil, completion: @escaping(ApplePayTokenResult) -> Void) {
        let applePayService = ApplePayService()
        guard applePayService.applePayIsAvailable() else { return }
        guard let applePayConfiguration = applePayConfiguration else { return }
        guard let setupInput = setupInput else {
            completion(.failure(error: DomainError.invalidTokenFormat))
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        let request = applePayService.createApplePayRequest(order: order, applePayConfiguration: applePayConfiguration, applePayData: applePayData)
        let viewModel = ApplePayViewModel(repository: ApplePayRepository(api: api), orderAccessToken: orderAccessToken)
        ApplePayViewController.getApplePay(request: request, viewModel: viewModel, sourceViewController: sourceViewController, resultsHandler: completion)
    }

    private func showApplePayResult(result: ApplePayTokenResult, orderAccessToken: AccessToken, setupInput: SetupInput, sourceViewController: UIViewController, order: Order, completion: @escaping(FlowResult) -> Void) {
        let input = ApplePayFlowInput(setupInput: setupInput, orderAccessToken: orderAccessToken)
        let featuresFactory = FeaturesFactory()
        let applePayFlowFactory = ApplePayResultFlowFactory(input: input, featuresFactory: featuresFactory)
        let coordinator = ApplePayResultCoordinator(factory: applePayFlowFactory, sourceViewController: sourceViewController)
        coordinator.order = order
        currentCoordinator = coordinator

        coordinator.resultCompletion = { result in
            completion(result)
            self.currentCoordinator = nil
        }

        coordinator.start(applePayTokenResult: result)
    }
}
