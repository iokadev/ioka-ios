//
//  ActionDTO+ToAction.swift
//  IOKA


import Foundation

extension ActionDTO {
    func toAction() throws -> Action {
        try Action(url: url)
    }
}
