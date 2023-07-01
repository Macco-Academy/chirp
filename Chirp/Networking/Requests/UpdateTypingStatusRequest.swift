//
//  UpdateTypingStatusRequest.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/14/23.
//

import Foundation

struct UpdateTypingStatusRequest: Codable {
    let id: String
    let typingStatus: [String: Bool]
}
