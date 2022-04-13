//
//  String+Card.swift
//  IokaDemoApp
//
//  Created by Тимур Табынбаев on 13.04.2022.
//

import Foundation

internal extension String {
    func trimPanMasked() -> String {
        String(self.suffix(8))
    }
}
