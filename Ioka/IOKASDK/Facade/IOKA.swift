//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit




class Ioka {
    static let shared = Ioka()
    var setupInput: SetupInput?
    var theme: Theme = .defaultTheme
    
    func setup(publicApiKey: String, theme: Theme? = .defaultTheme) {
        self.setupInput = SetupInput(apiKey: APIKey(key: publicApiKey), theme: theme ?? .defaultTheme)
        self.theme = theme ?? .defaultTheme
    }
    
    func startCheckoutFlow(viewController: UIViewController, orderAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else { return }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: viewController)
            let paymentMethodsFlowFactory = PaymentFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentCoordinator(factory: paymentMethodsFlowFactory, navigationController:  viewController.navigationController ?? UINavigationController())
            coordinator.start()
            
            coordinator.resultCompletion = { result in
                completion(result)
            }
        } catch let error {
            completion(.failed(error))
        }
    }
    
    func startCheckoutWithSavedCardFlow(viewController: UIViewController, orderAccessToken: String, card: GetCardResponse, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else { return }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: viewController, cardResponse: card)
            let paymentWithSavedCardFlowFactory = PaymentWithSavedCardFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentWithSavedCardCoordinator(factory: paymentWithSavedCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            coordinator.start()
            
            coordinator.resultCompletion = { result in
                completion(result)
            }
        } catch let error {
            completion(.failed(error))
        }
    }
    
    func startSaveCardFlow(viewController: UIViewController, customerAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else { return }

        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let customerAccesstoken = try AccessToken(token: customerAccessToken)
            let saveCardFlowInput = SaveCardFlowInput(setupInput: setupInput, customerAccesstoken: customerAccesstoken, hideSaveCardCheckbox: true)
            let saveCardFlowFactory = SaveCardFlowFactory(input: saveCardFlowInput, featuresFactory: featuresFactory)
            let coordinator = SaveCardCoordinator(factory: saveCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            coordinator.start()
            
            coordinator.resultCompletion = { result in
                completion(result)
            }
            
        } catch let error {
            completion(.failed(error))
        }
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(Result<[GetCardResponse], Error>) -> Void) {
        guard let setupInput = setupInput else { return }
        let api = API(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.getCards(customerAccessToken: customerAccessToken, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteSavedCard(customerAccessToken: String, cardId: String, completion: @escaping(Result<EmptyResponse, Error>) -> Void) {
        
        guard let setupInput = setupInput else { return }
        let api = API(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.deleteCard(customerAccessToken: customerAccessToken, cardId: cardId, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
}
