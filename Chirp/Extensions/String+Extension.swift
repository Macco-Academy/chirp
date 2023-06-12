//
//  String+Extension.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Foundation

extension String {
    var asUrl: URL? {
        URL(string: self)
    }
    
    var uniqueChatIdWithMe: String {
        let user1 = UserDefaults.standard.currentUser?.id ?? ""
        let user2 = self
        let value = user1.compare(user2).rawValue
        let id = value < 0 ? user1 + user2 : user2 + user1
        return id
    }
}
