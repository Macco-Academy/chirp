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
    
    var chatID: String? {
        return chat.id
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
    
    var lastMessage: Message? {
        return chat.lastMessage
    }
    
    var description: String? {
        return chat.lastMessage?.message
    }
    
    var timestamp: Date? {
        return chat.lastMessage?.timestamp
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
