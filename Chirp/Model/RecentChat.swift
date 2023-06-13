//
//  RecentChat.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation

struct RecentChat: Codable {
    let id: String?
    let members: [User]?
    let lastMessage: Message?
    let unreadCount: [String: Int]?
}
