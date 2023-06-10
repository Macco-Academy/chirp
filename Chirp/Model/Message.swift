//
//  Message.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation
 
struct Message: Codable {
    let senderId: String?
    let message: String?
    let timeStamp: Date?
}
