//
//  UserDefaults+Extension.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//

import Foundation

extension UserDefaults {
  private enum Keys: String {
    case currentUser
  }

  var currentUser: User? {
    get {
      if let data = object(forKey: Keys.currentUser.rawValue) as? Data {
        let user = try? JSONDecoder().decode(User.self, from: data)
        return user
      }
      return nil
    }

    set {
      if newValue == nil {
        removeObject(forKey: Keys.currentUser.rawValue)
      } else {
        let data = try? JSONEncoder().encode(newValue)
        setValue(data, forKey: Keys.currentUser.rawValue)
      }
      synchronize()
    }
  }
}
