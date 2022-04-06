//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


class IOKA: IokaThemeProtocol {
    static let shared = IOKA()
    var customerAccessToken: String?
    var orderAccessToken: String?
    var publicApiKey: String?
    var theme: IokaColors = .defaultTheme
    
    var setupInput: SetupInput?
    
    func setUp(publicApiKey: String, theme: IokaTheme = .defaultTheme) {
        self.theme = theme.iokaColors
        self.publicApiKey = publicApiKey
        
        self.setupInput = SetupInput(apiKey: APIKey(key: self.publicApiKey!), theme: Theme(colors: IokaColors.defaultTheme))
    }
    
    func startCheckoutFlow(viewController: UIViewController, orderAccessToken: String) {
        self.orderAccessToken = orderAccessToken
        guard let setupInput = setupInput else { return }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: viewController)
            let paymentMethodsFlowFactory = PaymentFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentCoordinator(factory: paymentMethodsFlowFactory, navigationController:  viewController.navigationController ?? UINavigationController())
            
            coordinator.start()
        } catch let error {
            print(error)
        }
    }
    
    func startCheckoutWithSavedCardFlow(viewController: UIViewController, orderAccessToken: String, card: GetCardResponse) {
        
        self.orderAccessToken = orderAccessToken
        guard let setupInput = setupInput else { return }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: viewController, cardResponse: card)
            let paymentWithSavedCardFlowFactory = PaymentWithSavedCardFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordnitar = PaymentWithSavedCardCoordinator(factory: paymentWithSavedCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            coordnitar.start()
        } catch let error {
            print(error)
        }
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(Result<[GetCardResponse], Error>) -> Void) {
        self.customerAccessToken = customerAccessToken
        API.shared.getCards(customerId: customerAccessToken.trimTokens()) { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let cards):
                completion(.success(cards))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func startSaveCardFlow(viewController: UIViewController, customerAccessToken: String) {
        let setupInput = SetupInput(apiKey: APIKey(key: self.publicApiKey!), theme: Theme(colors: IokaColors.defaultTheme))
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        
        do {
            let customerAccesstoken = try AccessToken(token: customerAccessToken)
            let saveCardFlowInput = SaveCardFlowInput(setupInput: setupInput, customerAccesstoken: customerAccesstoken, hideSaveCardCheckbox: true)
            let saveCardFlowFactory = SaveCardFlowFactory(input: saveCardFlowInput, featuresFactory: featuresFactory)
            let coordinator = SaveCardCoordinator(factory: saveCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            
            coordinator.start()
            
        } catch let error {
            print(error)
        }
    }
    
    func deleteSavedCard(customerId: String, cardId: String, completion: @escaping(IokaError?) -> Void) {
        API.shared.deleteCard(customerId: customerId, cardId: cardId) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success( _):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
