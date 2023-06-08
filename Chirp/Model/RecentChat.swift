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

extension RecentChat {
    
    var asChatListViewModel: ChatsListViewModel {
        
        let secondUser = members?.first{
            $0.id != "user1"
        }
        //check for unread count if >1000 & <5000 1k+ , >5000 5k+, >2000 2k+ and pass it to unreadcount
        return ChatsListViewModel(imageUrl: secondUser?.profileImage,
                                  title: secondUser?.name,
                                  description: self.lastMessage?.message,
                                  timeStamp: self.lastMessage?.timeStamp,
                                  unreadCount: self.unreadCount?["user1"])
    }
}
