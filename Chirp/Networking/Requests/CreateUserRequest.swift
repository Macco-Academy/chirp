//
//  CreateUserRequest.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/10/23.
//

import Foundation

struct CreateUserRequest: Encodable {
    let userID: String
    let name: String
    let phoneNumber: String
    let profilePicture: String?
}
