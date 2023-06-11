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
    //TODO: fix this with actual data
    var asChatListViewModel: ChatsListViewModel {
        let secondUser = members?.first{
            $0.id != "user1"
        }
        //TODO: check for unread count if >1000 & <5000 =  1k+ , >5000 = 5k+, >2000 = 2k+ and pass it to unreadCount
        return ChatsListViewModel(imageUrl: secondUser?.profilePicture,
                                  title: secondUser?.name,
                                  description: self.lastMessage?.message,
                                  timeStamp: self.lastMessage?.timestamp,
                                  unreadCount: self.unreadCount?["user1"])
    }
}
