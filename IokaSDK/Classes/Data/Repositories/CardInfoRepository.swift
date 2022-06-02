//
//  CardInfoRepository.swift
//  Ioka
//
//  Created by Тимур Табынбаев on 19.04.2022.
//

import Foundation

final class CardInfoRepository {
    private let api: IokaAPIProtocol
    
    init(api: IokaAPIProtocol) {
        self.api = api
    }
    
    func getPaymentSystem(partialBin: String, completion: @escaping (Result<String, Error>) -> Void) {
        api.getBrand(partialBin: partialBin) { result in
            completion(result.map { $0.brand.rawValue })
        }
    }
    
    func getEmitter(bin: String, completion: @escaping (Result<EmitterDTO, Error>) -> Void) {
        api.getEmitterByBinCode(binCode: bin, completion: completion)
    }
}
