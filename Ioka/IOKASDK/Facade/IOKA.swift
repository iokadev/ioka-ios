//
//  iOKA.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit


// REVIEW: Надо назвать Ioka
class IOKA: IokaThemeProtocol {
    static let shared = IOKA()
    var theme: IokaColors = .defaultTheme
    
    var setupInput: SetupInput?
    
    // REVIEW: setup(apiKey:theme:)
    func setUp(publicApiKey: String, theme: IokaTheme = .defaultTheme) {
        self.theme = theme.iokaColors
        self.setupInput = SetupInput(apiKey: APIKey(key: publicApiKey), theme: Theme(colors: IokaColors.defaultTheme))
    }
    
    // REVIEW: startPaymentFlow(sourceViewController:orderAccessToken:completion:)
    func startCheckoutFlow(viewController: UIViewController, orderAccessToken: String) {
        guard let setupInput = setupInput else {
            // REVIEW: assertionFailure
            return
        }
        
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
    
    // REVIEW: startPaymentWithSavedCardFlow(sourceViewController:orderAccessToken:card:completion:)
    func startCheckoutWithSavedCardFlow(viewController: UIViewController, orderAccessToken: String, card: GetCardResponse) {
        guard let setupInput = setupInput else { return }
        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let token = try AccessToken(token: orderAccessToken)
            let input = PaymentWithSavedCardFlowInput(setupInput: setupInput, orderAccessToken: token, viewController: viewController, cardResponse: card)
            let paymentWithSavedCardFlowFactory = PaymentWithSavedCardFlowFactory(input: input, featuresFactory: featuresFactory)
            // REVIEW: coordinator
            let coordnitar = PaymentWithSavedCardCoordinator(factory: paymentWithSavedCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            coordnitar.start()
        } catch let error {
            print(error)
        }
    }
    
    func getCards(customerAccessToken: String, completion: @escaping(Result<[GetCardResponse], Error>) -> Void) {
        guard let setupInput = setupInput else { return }
        let api = API(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.getCards(customerAccessToken: customerAccessToken, completion: completion)
        } catch let error {
            print(error)
        }
    }
    
    // REVIEW: sourceViewController,completion
    func startSaveCardFlow(viewController: UIViewController, customerAccessToken: String) {
        guard let setupInput = setupInput else { return }

        let featuresFactory = FeaturesFactory(setupInput: setupInput)
        
        do {
            let customerAccesstoken = try AccessToken(token: customerAccessToken)
            
            // REVIEW: поля hideSaveCardCheckbox здесь не должно быть, потому что для флоу save card оно не имеет смысла
            let saveCardFlowInput = SaveCardFlowInput(setupInput: setupInput, customerAccesstoken: customerAccesstoken, hideSaveCardCheckbox: true)
            let saveCardFlowFactory = SaveCardFlowFactory(input: saveCardFlowInput, featuresFactory: featuresFactory)
            let coordinator = SaveCardCoordinator(factory: saveCardFlowFactory, navigationController: viewController.navigationController ?? UINavigationController())
            
            
            coordinator.start()
            
        } catch let error {
            print(error)
        }
    }
    
    // REVIEW: здесь лучше Error? передавать в completion
    func deleteSavedCard(customerAccessToken: String, cardId: String, completion: @escaping(Result<EmptyResponse, Error>) -> Void) {
        
        guard let setupInput = setupInput else { return }
        let api = API(apiKey: setupInput.apiKey)
        
        do {
            let customerAccessToken = try AccessToken(token: customerAccessToken)
            api.deleteCard(customerAccessToken: customerAccessToken, cardId: cardId, completion: completion)
        } catch let error {
            print(error)
        }
    }
}
