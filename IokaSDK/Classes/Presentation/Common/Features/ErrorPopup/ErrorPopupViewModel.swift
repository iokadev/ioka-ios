//
//  ErrorPopupViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol ErrorPopupNavigationDelegate: AnyObject {
    func errorPopupDidClose(error: Error)
}

internal class ErrorPopupViewModel {
    let error: Error
    weak var delegate: ErrorPopupNavigationDelegate?
    
    init(error: Error, delegate: ErrorPopupNavigationDelegate) {
        self.error = error
        self.delegate = delegate
    }
    
    func close() {
        delegate?.errorPopupDidClose(error: error)
    }
}
