//
//  MessageCellViewModel.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import UIKit

struct MessageCellViewModel {
    let chatId: String
    let message: String
    let timestamp: String
    let senderId: String
    
    var iAmSender: Bool {
        return senderId == "user1" // UserDefaults.standard.currentUser?.id
    }
    
    var textColor: UIColor {
        iAmSender ? .white : .black
    }
    
    var backgroundColor: UIColor {
        iAmSender ? .appBrown : .appBrownSecondary
    }
    
    var roundedCorners: UIRectCorner {
        if iAmSender {
            return [.topLeft, .topRight, .bottomLeft]
        } else {
            return [.topLeft, .topRight, .bottomRight]
        }
    }
}
