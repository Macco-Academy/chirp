//
//  ResetUnreadCountRequest.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 12.06.23.
//

import Foundation

struct ResetUnreadCountRequest: Codable {
    let id: String?
    let unreadCount: [String: Int]?
}
