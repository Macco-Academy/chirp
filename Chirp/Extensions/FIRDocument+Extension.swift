//
//  FIRDocument+Extension.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 10.06.23.
//

import Foundation
import FirebaseFirestore

public typealias FIRDocument = [String: Any]

extension FIRDocument {
    public func decode<T: Decodable>(to: T.Type) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension Array where Element == QueryDocumentSnapshot {
  public func decode<T: Decodable>(to: [T].Type) -> [T]? {
    compactMap { $0.data().decode(to: T.self) }
  }
}
