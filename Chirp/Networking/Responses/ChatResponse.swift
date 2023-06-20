//
//  ChatResponse.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Foundation

struct ChatResponse: Codable {
    let id: String?
    let members: [String]?
    var lastMessage: Message?
    var unreadCount: [String: Int]?
    var typingStatus: [String: Bool]?
}
