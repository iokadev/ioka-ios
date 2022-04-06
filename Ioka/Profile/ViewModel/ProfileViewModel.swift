//
//  ProfileViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


class ProfileViewModel {
    
    func getProfile(completion: @escaping(String) -> Void) {
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            DemoAppApi.shared.getProfile { [weak self] result in
                guard let _ = self else { return }
                
                switch result {
                case .success(let createOrderResponse):
                    completion(createOrderResponse.customer_access_token)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
