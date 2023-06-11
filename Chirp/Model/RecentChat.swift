//
//  RecentChat.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation

struct RecentChatResponse: Codable {
    let id: String?
    let members: [String]?
    let lastMessage: String
    let timestamp: Date?
    let unreadCount: [String: Int]?
}

struct RecentChat: Codable {
    let id: String?
    let members: [User]?
    let lastMessage: String?
    let timestamp: Date?
    let unreadCount: [String: Int]?
}
