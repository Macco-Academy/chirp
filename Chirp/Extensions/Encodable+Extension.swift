//
//  Encodable+Extension.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 10.06.23.
//

import Foundation

extension Encodable {
  public var asDictionary: [String: Any] {
    guard let data = try? JSONEncoder().encode(self) else { return [:] }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { ($0 as? [String: Any]) ?? [:] } ?? [:]
  }
}
