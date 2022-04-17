//
//  Ioka.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


/// Класс-фасад Ioka SDK. Реализован как синглтон.
/// Предоставляет методы для инициализации SDK, запуска сценариев оплаты и сохранения карты, и работы с сохраненными картами.
public class Ioka {
    /// Синглтон
    static public let shared = Ioka()
    var setupInput: SetupInput?
    var theme: IokaTheme = .default
    var currentCoordinator: Coordinator?
    
    
    /// Метод для инициализии SDK. Необходимо вызвать до того, как обращаться к любым другим методам этого класса.
    ///
    /// - Parameters:
    ///   - apiKey: Публичный API-ключ, полученные при регистрации в качестве клиента Ioka
    ///   - theme: Конфигурирует внешний вид экранов Ioka SDK. По умолчанию - объект IokaTheme.default.
    ///   - locale: Конфигурирует локализацию текстов в Ioka SDK. По умолчанию - .automatic.
    ///   Передавать другое значение нужно в том случае, если язык в вашем приложении выбирается вручную.
    public func setup(apiKey: String, theme: IokaTheme = .default, locale: IokaLocale = .automatic) {
        self.setupInput = SetupInput(apiKey: APIKey(key: apiKey), theme: theme)
        self.theme = theme
        applyTheme(theme)
        updateLocale(locale)
    }
    
    /// Метод для запуска сценария оплаты новой картой. Показывает форму для ввода данных карты.
    /// При необходимости проводит проверку 3DSecure. Отображает результат оплаты пользователю.
    /// - Parameters:
    ///   - sourceViewController: Объект UIViewController для экрана, с которого пользователь запускает оплату.
    ///   Перед открытием формы для ввода данных карты Ioka SDK получает объект Order из Ioka API. Во время этого запроса
    ///   поверх sourceViewController показывается индикатор загрузки и могут отображаться ошибки. Также с него происходит
    ///   переход на экраны Ioka SDK.
    ///   - orderAccessToken: Токен для доступа к заказу, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, которое вызывается после того, как пользователь закрывает экран результата оплаты или
    ///   любой экран до него. Принимает значение FlowResult: .succeeded - если оплата прошла успешно, .failed - если карта
    ///   была отклонена, .cancelled - если пользователь закрыл экран оплаты или экран 3DSecure.
    public func startPaymentFlow(sourceViewController: UIViewController, orderAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: sourceViewController, theme: theme)
            let paymentMethodsFlowFactory = PaymentFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentCoordinator(factory: paymentMethodsFlowFactory, sourceViewController: sourceViewController)
            coordinator.start()
            currentCoordinator = coordinator
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
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
    ///   отклонена, .cancelled - если пользователь закрыл экран ввода CVV или экран 3DSecure.
    public func startPaymentWithSavedCardFlow(sourceViewController: UIViewController, orderAccessToken: String, card: SavedCard, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: sourceViewController, cardResponse: card, theme: theme)
            let paymentWithSavedCardFlowFactory = PaymentWithSavedCardFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentWithSavedCardCoordinator(factory: paymentWithSavedCardFlowFactory, navigationController: sourceViewController.navigationController ?? UINavigationController())
            currentCoordinator = coordinator
            coordinator.start()
            
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
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
    ///   остаётся на экране сохранения.
    public func startSaveCardFlow(sourceViewController: UIViewController, customerAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }

        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let customerAccesstoken = try AccessToken(token: customerAccessToken)
            let saveCardFlowInput = SaveCardFlowInput(setupInput: setupInput, customerAccesstoken: customerAccesstoken, theme: theme)
            let saveCardFlowFactory = SaveCardFlowFactory(input: saveCardFlowInput, featuresFactory: featuresFactory)
            let coordinator = SaveCardCoordinator(factory: saveCardFlowFactory, navigationController: sourceViewController.navigationController ?? UINavigationController())
            currentCoordinator = coordinator
            coordinator.start()
            
            coordinator.resultCompletion = { result in
                completion(result)
                self.currentCoordinator = nil
            }
            
        } catch let error {
            completion(.failed(error))
        }
    }
    
    /// Метод для получения сохраненных карт пользователя
    /// - Parameters:
    ///   - customerAccessToken: Токен для доступа к пользователю, который приложение получает от своего бэкенда.
    ///   - completion: Замыкание, в которое передаётся результат запроса сохраненных карт.
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
    ///   error - если произошла ошибка.
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
    
    /// Переключает локаль для локализации текстов в ioka SDK. Необходимо вызвать, если пользователь переключил язык
    /// в приложении.
    public func updateLocale(_ localeParam: IokaLocale) {
        locale = localeParam
    }
    
    private func applyTheme(_ theme: IokaTheme) {
        colors = theme.colors
        typography = theme.typography
    }
}
