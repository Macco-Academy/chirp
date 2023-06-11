//
//  UpdateLastMessageRequest.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Foundation

struct UpdateLastMessageRequest: Codable {
    let lastMessage: Message
    let unreadCount: [String: Int]
    var timestamp = Date()
}
