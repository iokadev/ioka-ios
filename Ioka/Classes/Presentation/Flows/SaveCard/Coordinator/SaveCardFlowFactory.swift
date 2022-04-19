//
//  SaveCardFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


internal class SaveCardFlowFactory {
    let input: SaveCardFlowInput
    let featuresFactory: FeaturesFactory
    
    init(input: SaveCardFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    func makeSaveCard(delegate: SaveCardNavigationDelegate) -> SaveCardViewController{
        featuresFactory.makeSaveCard(delegate: delegate, customerAccessToken: self.input.customerAccesstoken, repository: savedCardRepository(), theme: input.theme)
    }
    
    func makeThreeDSecure(delegate: ThreeDSecureNavigationDelegate, action: Action, cardId: String) -> ThreeDSecureViewController {
        featuresFactory.makeThreeDSecure(delegate: delegate,
                                         action: action, input: .saveCard(repository: savedCardRepository(),
                                                                          customerAccessToken: input.customerAccesstoken,
                                                                          cardId: cardId))
    }
    
    func savedCardRepository() -> SavedCardRepository {
        return SavedCardRepository(api: api)
    }
    
    private lazy var api: IokaAPIProtocol = {
        IokaApi(apiKey: input.setupInput.apiKey)
    }()
}
