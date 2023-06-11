//
//  CreateNewChatRequest.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Foundation

struct CreateNewChatRequest: Codable {
  let id: String
  let members: [String]
  var timestamp = Date()
}

