//
//  ActionDTO+ToAction.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

extension ActionDTO {
    func toAction() throws -> Action {
        try Action(url: url)
    }
}
