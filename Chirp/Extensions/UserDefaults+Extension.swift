//
//  UserDefaults+Extension.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//  Created by Kwaku Dapaah on 6/10/23.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case currentUser, otpVerificationID, fcmToken
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
    
    var otpVerificationID: String? {
        get {
            return string(forKey: Keys.otpVerificationID.rawValue)
        }
        
        set {
            setValue(newValue, forKey: Keys.otpVerificationID.rawValue)
            synchronize()
        }
    }
    
    var fcmToken: String? {
        get {
            return string(forKey: Keys.fcmToken.rawValue)
        }
        
        set {
            setValue(newValue, forKey: Keys.fcmToken.rawValue)
            synchronize()
        }
    }
}
