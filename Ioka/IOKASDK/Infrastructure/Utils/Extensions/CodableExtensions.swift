//
//  CodableExtensions.swift
//  iOKA
//
//  Created by ablai erzhanov on 03.03.2022.
//

import Foundation


internal extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]
  }
}


