//
//  User.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 7.06.23.
//

import Foundation
import UIKit

struct User: Codable{
    var id:String?
    var name: String?
    var phoneNumber: String?
    var profilePicture: String?
}

extension User {
    var asContactDetail: ContactsDetails {
        ContactsDetails(image: profilePicture, text: name ?? "")
    }
}
