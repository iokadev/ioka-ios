//
//  ErrorPopUpViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol ErrorPopUpNavigationDelegate {
    func dismiss()
}


class ErrorPopUpViewModel {
    var delegate: ErrorPopUpNavigationDelegate?
    
    func dismiss() {
        delegate?.dismiss()
    }
}
