//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


public class Ioka {
    static let shared = Ioka()
    var setupInput: SetupInput?
    var theme: Theme = .defaultTheme
    var currentCoordinator: Coordinator?
    
    func setup(apiKey: String, theme: Theme? = .defaultTheme) {
        self.setupInput = SetupInput(apiKey: APIKey(key: apiKey), theme: theme ?? .defaultTheme)
        self.theme = theme ?? .defaultTheme
    }
    
    func startCheckoutFlow(sourceViewController: UIViewController, orderAccessToken: String, completion: @escaping(FlowResult) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failed(DomainError.invalidTokenFormat))
            return
        }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: sourceViewController, theme: theme)
            let paymentMethodsFlowFactory = PaymentFlowFactory(input: input, featuresFactory: featuresFactory)
            let coordinator = PaymentCoordinator(factory: paymentMethodsFlowFactory, navigationController:  sourceViewController.navigationController ?? UINavigationController())
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
    
    func startCheckoutWithSavedCardFlow(sourceViewController: UIViewController, orderAccessToken: String, card: SavedCardDTO, completion: @escaping(FlowResult) -> Void) {
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
    
    func startSaveCardFlow(sourceViewController: UIViewController, customerAccessToken: String, completion: @escaping(FlowResult) -> Void) {
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
    
    func getCards(customerAccessToken: String, completion: @escaping(Result<[SavedCardDTO], Error>) -> Void) {
        guard let setupInput = setupInput else {
            completion(.failure(DomainError.invalidTokenFormat))
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.getCards(customerAccessToken: customerAccessToken, completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteSavedCard(customerAccessToken: String, cardId: String, completion: @escaping(Error?) -> Void) {
        
        guard let setupInput = setupInput else {
            completion(DomainError.invalidTokenFormat)
            return
        }
        let api = IokaApi(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.deleteCard(customerAccessToken: customerAccessToken, cardId: cardId) { result in
                switch result {
                case .success( _):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        } catch let error {
            completion(error)
        }
    }
}
