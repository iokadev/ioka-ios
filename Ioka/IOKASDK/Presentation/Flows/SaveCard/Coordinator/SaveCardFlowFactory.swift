//
//  SaveCardFlowFactory.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


struct SaveCardFlowInput {
    let setupInput: SetupInput
    let customerAccesstoken: AccessToken
    let hideSaveCardCheckbox: Bool
}


class SaveCardFlowFactory {
    let input: SaveCardFlowInput
    let featuresFactory: FeaturesFactory
    
    init(input: SaveCardFlowInput, featuresFactory: FeaturesFactory) {
        self.input = input
        self.featuresFactory = featuresFactory
    }
    
    func makeSaveCard(delegate: SaveCardNavigationDelegate) -> SaveCardViewController{
        featuresFactory.makeSaveCard(delegate: delegate, customerAccessToken: self.input.customerAccesstoken, repository: savedCardRepository())
    }
    
    func make3DSecure(delegate: ThreeDSecureNavigationDelegate, url: URL, cardId: String) -> ThreeDSecureViewController {
        featuresFactory.make3DSecure(delegate: delegate, state: .saveCard(repository: savedCardRepository(), customerAccessToken: input.customerAccesstoken), url: url, cardId: cardId, paymentId: nil)
    }
    
    func savedCardRepository() -> SavedCardRepository {
        return SavedCardRepository(api: api)
    }
    
    private lazy var api: IokaAPIProtocol = {
        API(apiKey: input.setupInput.apiKey)
    }()
}
