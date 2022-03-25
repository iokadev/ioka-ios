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
            DemoAppApi.shared.getProfile { [weak self] result, error in
                guard let _ = self else { return }
                guard let customerAccessToken = result?.customer_access_token else { return }
                DispatchQueue.main.async {
                    completion(customerAccessToken)
                }
            }
        }
    }
}
