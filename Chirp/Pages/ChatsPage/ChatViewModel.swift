//
//  ChatViewModel.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/11/23.
//

import Foundation

class ChatViewModel {
    
    private let chat: RecentChat
    
    init(chat: RecentChat) {
        self.chat = chat
    }
    
    var sender: User? {
        return chat.members?.first(where: { $0.id == UserDefaults.standard.currentUser?.id })
    }
    
    var receiver: User? {
        return chat.members?.first(where: { $0.id != UserDefaults.standard.currentUser?.id })
    }
    
    var imageUrl: String? {
        return receiver?.profilePicture
    }
    
    var title: String? {
        return receiver?.name
    }
    
    var description: String? {
        return chat.lastMessage
    }
    
    var timestamp: Date? {
        guard let timestamp = chat.timestamp else { return nil }
        
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    var unreadCount: String? {
        guard let senderId = sender?.id,
              let count = chat.unreadCount?[senderId] else { return "0" }
        
        if count > 1000 {
            let thousands = count / 1000
            return "\(thousands)k+"
        } else {
            return "\(count)"
        }
    }
}
