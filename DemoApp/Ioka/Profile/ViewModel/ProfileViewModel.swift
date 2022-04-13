//
//  ProfileViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import Ioka

internal class ProfileViewModel {
    var locale: Locale {
        get {
            Locale.current
        }
        set {
            Locale.current = newValue
            Ioka.shared.updateLocale(newValue.toIokaLocale())
        }
    }
    
    func getProfile(completion: @escaping(String) -> Void) {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            DemoAppApi.shared.getProfile { [weak self] result in
                guard let _ = self else { return }
                
                switch result {
                case .success(let createOrderResponse):
                    completion(createOrderResponse.customer_access_token)
                case .failure:
                    break
                }
            }
        }
    }
}
