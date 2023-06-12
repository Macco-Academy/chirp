//
//  Message.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation

enum MessageType: String, Codable {
  case text
}

struct Message: Codable {
    let id: String?
    let chatId: String?
    let senderId: String?
    let message: String?
    var timestamp: Date? = Date()
    var type: MessageType = .text
    
    var iAmSender: Bool {
        return (senderId ?? "") == (UserDefaults.standard.currentUser?.id ?? "")
    }
}

extension Message {
    var asMessageCellViewModel: MessageCellViewModel {
        MessageCellViewModel(chatId: chatId ?? "",
                             message: message ?? "",
                             timestamp: timestamp?.asTimeAgo ?? "",
                             senderId: senderId ?? "")
    }
}
